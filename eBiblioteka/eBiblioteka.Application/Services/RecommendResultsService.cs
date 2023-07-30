using AutoMapper;
using FluentValidation;
using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure;
using eBiblioteka.Infrastructure.Interfaces;
using Microsoft.ML.Trainers;
using Microsoft.ML;
using Microsoft.ML.Data;

namespace eBiblioteka.Application
{
    public class RecommendResultsService : IRecommendResultsService
    {
        protected readonly IMapper Mapper;
        protected readonly UnitOfWork UnitOfWork;
        protected readonly IRecommendResultsRepository CurrentRepository;
        protected readonly IValidator<RecommendResultUpsertDto> Validator;
        private readonly IBooksRepository _booksRepository;
        private readonly IUsersRepository _usersRepository;

        public RecommendResultsService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<RecommendResultUpsertDto> validator, IPhotosService photosService, IRecommendResultsRepository currentRepository, IBooksRepository booksRepository, IUsersRepository usersRepository) 
        {
            Mapper = mapper;
            UnitOfWork = (UnitOfWork)unitOfWork;
            Validator = validator;
            CurrentRepository = currentRepository;
            _booksRepository = booksRepository;
            _usersRepository = usersRepository;
        }

        public virtual async Task<PagedList<RecommendResultDto>> GetPagedAsync(BaseSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            var pagedList = await CurrentRepository.GetPagedAsync(searchObject, cancellationToken);
            return Mapper.Map<PagedList<RecommendResultDto>>(pagedList);
        }

        public async Task<RecommendResultDto?> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            var entity = await CurrentRepository.GetByIdAsync(id, cancellationToken);
            return Mapper.Map<RecommendResultDto>(entity);
        }

        static MLContext mlContext = null;
        static object isLocked = new object();
        static ITransformer model = null;


        public List<BookDto> Recommend(int id)
        {
            lock (isLocked)
            {
                if (mlContext == null)
                {
                    mlContext = new MLContext();

                    var tmpData = _usersRepository.UsersWithReadHistory();

                    var data = new List<BookEntry>();

                    foreach (var x in tmpData)
                    {
                        if (x.OpenedBooks.Count > 1)
                        {
                            var distinctItemId = x.OpenedBooks.Select(y => y.BookId).ToList();

                            distinctItemId.ForEach(y =>
                            {
                                var relatedItems = x.OpenedBooks.Where(z => z.BookId != y);

                                foreach (var z in relatedItems)
                                {
                                    data.Add(new BookEntry()
                                    {
                                        BookID = (uint)y,
                                        CoOpenedBookID = (uint)z.BookId,
                                    });
                                }
                            });
                        }
                    }

                    var trainData = mlContext.Data.LoadFromEnumerable(data);

                    MatrixFactorizationTrainer.Options options = new MatrixFactorizationTrainer.Options();
                    options.MatrixColumnIndexColumnName = nameof(BookEntry.BookID);
                    options.MatrixRowIndexColumnName = nameof(BookEntry.CoOpenedBookID);
                    options.LabelColumnName = "Label";
                    options.LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass;
                    options.Alpha = 0.01;
                    options.Lambda = 0.025;
                    // For better results use the following parameters
                    options.NumberOfIterations = 100;
                    options.C = 0.00001;

                    var est = mlContext.Recommendation().Trainers.MatrixFactorization(options);

                    model = est.Fit(trainData);
                }
            }

            var books = _booksRepository.GetExceptById(id);

            var predictionResult = new List<Tuple<Book, float>>();

            foreach (var book in books)
            {

                var predictionengine = mlContext.Model.CreatePredictionEngine<BookEntry, CoBook_prediction>(model);
                var prediction = predictionengine.Predict(
                                         new BookEntry()
                                         {
                                             BookID = (uint)id,
                                             CoOpenedBookID = (uint)book.Id
                                         });


                predictionResult.Add(new Tuple<Book, float>(book, prediction.Score));
            }


            var finalResult = predictionResult.OrderByDescending(x => x.Item2).Select(x => x.Item1).Take(3).ToList();

            return Mapper.Map<List<BookDto>>(finalResult);

        }

        public async Task<List<RecommendResultDto>> TrainBooksModelAsync(CancellationToken cancellationToken = default)
        {
            var bookResult = await _booksRepository.GetPagedAsync(new BooksSearchObject() { PageSize = 100000 }, cancellationToken);
            var books = bookResult.Items.ToList();

            List<RecommendResult> recommendList = new List<RecommendResult>();

            foreach (var book in books)
            {
                var recommendedBooks = Recommend(book.Id);

                var resultRecoomend = new RecommendResult()
                {
                    BookId = book.Id,
                    FirstCobookId = recommendedBooks[0].Id,
                    SecondCobookId = recommendedBooks[1].Id,
                    ThirdCobookId = recommendedBooks[2].Id
                };
                recommendList.Add(resultRecoomend);
            }
            await CurrentRepository.CreateNewRecommendation(recommendList, cancellationToken);
            await UnitOfWork.SaveChangesAsync();

            return Mapper.Map<List<RecommendResultDto>>(recommendList);
        }

        public  List<RecommendResultDto> TrainBooks()
        {
            var books =  _booksRepository.GetAll();

            List<RecommendResult> recommendList = new List<RecommendResult>();

            foreach (var book in books)
            {
                var recommendedBooks = Recommend(book.Id);

                var resultRecoomend = new RecommendResult()
                {
                    BookId = book.Id,
                    FirstCobookId = recommendedBooks[0].Id,
                    SecondCobookId = recommendedBooks[1].Id,
                    ThirdCobookId = recommendedBooks[2].Id
                };
                recommendList.Add(resultRecoomend);
            }
             CurrentRepository.UpdateRecommendation(recommendList);
             UnitOfWork.SaveChanges();

            return Mapper.Map<List<RecommendResultDto>>(recommendList);
        }


    }

    public class CoBook_prediction
    {
        public float Score { get; set; }
    }

    public class BookEntry
    {
        [KeyType(count: 27)]
        public uint BookID { get; set; }

        [KeyType(count: 27)]
        public uint CoOpenedBookID { get; set; }

        public float Label { get; set; }
    }
}
