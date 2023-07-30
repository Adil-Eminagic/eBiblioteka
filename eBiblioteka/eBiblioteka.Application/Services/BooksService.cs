using AutoMapper;
using FluentValidation;
using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure;
using eBiblioteka.Infrastructure.Interfaces;
using Microsoft.EntityFrameworkCore.Metadata.Conventions;
using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;
using Microsoft.EntityFrameworkCore;

namespace eBiblioteka.Application
{
    public class BooksService : BaseService<Book, BookDto, BookUpsertDto, BooksSearchObject, IBooksRepository>, IBooksService
    {
        private readonly IPhotosService _photosService;
        private readonly IBookFilesService _bookFilesService;
        private readonly IUsersRepository _usersRepository;


        public BooksService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<BookUpsertDto> validator, IPhotosService photosService, IBookFilesService bookFilesService, IUserBooksRepository userBooksRepository, IUsersService usersService, IUsersRepository usersRepository) : base(mapper, unitOfWork, validator)
        {
            this._photosService = photosService;
            _bookFilesService = bookFilesService;
            _usersRepository = usersRepository;
        }

        //public async override Task<BookDto?> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        //{
        //    var entity = await CurrentRepository.GetByIdAsync(id, cancellationToken);
        //    var dto = Mapper.Map<BookDto>(entity);
        //    if (entity.UserRate.Count > 0)
        //    {
        //        int ave = 0;
        //        foreach (var item in entity.UserRate)
        //        {
        //            ave += item.Stars;
        //        }
        //        dto.AverageRate = ave / entity.UserRate.Count;
        //    }

        //    return dto;
        //}

        public override async Task<PagedList<BookDto>> GetPagedAsync(BooksSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            var pagedList = await CurrentRepository.GetPagedAsync(searchObject, cancellationToken);
            var dtos = Mapper.Map<PagedList<BookDto>>(pagedList);

            if (pagedList.Items != null && pagedList.Items.Count > 0)
            {
                for (int i = 0; i < pagedList.Items.Count(); i++)
                {
                    if (pagedList.Items[i].UserRate.Count > 0)
                    {
                        int ave = 0;
                        foreach (var z in pagedList.Items[i].UserRate)
                        {
                            ave += z.Stars;
                        }
                        dtos.Items[i].AverageRate = ave / pagedList.Items[i].UserRate.Count();
                    }
                }
            }

            return dtos;
        }

        public async Task<IEnumerable<BookDto>> GetByAuthorIdAsync(int authorId, CancellationToken cancellationToken)
        {
            var books = await CurrentRepository.GetByAuthorIdAsync(authorId, cancellationToken);
            return Mapper.Map<IEnumerable<BookDto>>(books);
        }

        public async override Task<BookDto> AddAsync(BookUpsertDto dto, CancellationToken cancellationToken = default)
        {
            await ValidateAsync(dto, cancellationToken);

            var entity = Mapper.Map<Book>(dto);
            if (dto.image != null)
            {
                PhotoUpsertDto photoUpsertDto = new PhotoUpsertDto();
                photoUpsertDto.Data = dto.image;
                var photo = await _photosService.AddAsync(photoUpsertDto);
                entity.CoverPhotoId = photo.Id;
            }
            if (dto.document != null)
            {
                BookFileUpsertDto bookFileUpsertDto = new BookFileUpsertDto();
                bookFileUpsertDto.Name = dto.document.Name;
                bookFileUpsertDto.Data = dto.document.Data;
                var file = await _bookFilesService.AddAsync(bookFileUpsertDto);
                entity.BookFileId = file.Id;
            }

            await CurrentRepository.AddAsync(entity, cancellationToken);
            await UnitOfWork.SaveChangesAsync(cancellationToken);
            return Mapper.Map<BookDto>(entity);
        }

        public async override Task<BookDto> UpdateAsync(BookUpsertDto dto, CancellationToken cancellationToken = default)
        {
            await ValidateAsync(dto, cancellationToken);

            var book = await CurrentRepository.GetByIdAsync(dto.Id.Value, cancellationToken);// uvjeka await koristiti

            if (book == null)
                throw new Exception("Book not found.");

            var exsistringCoverPhotoId = book.CoverPhotoId ?? 0;
            var exsistringBookFileId = book.BookFileId ?? 0;

            Mapper.Map(dto, book);

            if (dto.image == null && exsistringCoverPhotoId > 0)// ne može se null dodsjeliti 0
            {
                book.CoverPhotoId = exsistringCoverPhotoId;
            }
            else if (dto.image != null)
            {
                if (exsistringCoverPhotoId > 0)
                {
                    PhotoUpsertDto photoUpsertDto = new PhotoUpsertDto() { Id = exsistringCoverPhotoId, Data = dto.image };
                    var photo = await _photosService.UpdateAsync(photoUpsertDto);
                }
                else
                {
                    PhotoUpsertDto photoUpsertDto = new PhotoUpsertDto() { Id = 0, Data = dto.image };
                    var photo = await _photosService.AddAsync(photoUpsertDto);
                    book.CoverPhotoId = photo.Id;
                }
            }


            if (dto.document == null && exsistringBookFileId > 0)// ne može se null dodsjeliti 0
            {
                book.BookFileId = exsistringBookFileId;
            }
            else if (dto.document != null)
            {
                if (exsistringBookFileId > 0)
                {
                    BookFileUpsertDto fileUpsertDto = new BookFileUpsertDto() { Id = exsistringBookFileId, Name = dto.document.Name, Data = dto.document.Data };
                    var file = await _bookFilesService.UpdateAsync(fileUpsertDto);
                }
                else
                {
                    BookFileUpsertDto fileUpsertDto = new BookFileUpsertDto() { Id = 0, Name = dto.document.Name, Data = dto.document.Data };
                    var file = await _bookFilesService.AddAsync(fileUpsertDto);
                    book.BookFileId = file.Id;
                }
            }

            CurrentRepository.Update(book);
            await UnitOfWork.SaveChangesAsync();

            return Mapper.Map<BookDto>(book);
        }

        public async Task<BookDto> OpenBookAsync(int bookId, CancellationToken cancellationToken)
        {
            var book = await CurrentRepository.GetByIdAsync(bookId, cancellationToken);
            if (book == null)
                throw new Exception("Book not found.");

            book.OpeningCount++;

            CurrentRepository.Update(book);
            await UnitOfWork.SaveChangesAsync();

            return Mapper.Map<BookDto>(book);
        }

        public async Task<BookDto> DeactivateAsync(int bookId, CancellationToken cancellationToken = default)
        {
            var book = await CurrentRepository.GetByIdAsync(bookId, cancellationToken);

            if (book == null)
                throw new UserNotFoundException();

            if (book.isActive == false)
                throw new Exception("Ne mozete deaktivirati knjigu koji je vec deakativirana");

            book.isActive = false;

            CurrentRepository.Update(book);
            await UnitOfWork.SaveChangesAsync();

            return Mapper.Map<BookDto>(book);
        }

        public async Task<BookDto> ActivateAsync(int bookId, CancellationToken cancellationToken = default)
        {
            var book = await CurrentRepository.GetByIdAsync(bookId, cancellationToken);

            if (book == null)
                throw new UserNotFoundException();

            if (book.isActive == true)
                throw new Exception("Ne mozete aktivirati knjigu koji je aktivna");

            book.isActive = true;

            CurrentRepository.Update(book);
            await UnitOfWork.SaveChangesAsync();

            return Mapper.Map<BookDto>(book);
        }




        //static MLContext mlContext = null;
        //static object isLocked= new object();
        // static ITransformer model = null;


        //public List<BookDto> Recommend(int id)
        //{
        //    lock (isLocked)
        //    {
        //        if (mlContext == null)
        //        {
        //            mlContext = new MLContext();

        //            var tmpData =  _usersRepository.UsersWithReadHistory();

        //            var data = new List<BookEntry>();

        //            foreach (var x in tmpData)
        //            {
        //                if (x.OpenedBooks.Count > 1)
        //                {
        //                    var distinctItemId = x.OpenedBooks.Select(y => y.BookId).ToList();

        //                    distinctItemId.ForEach(y =>
        //                    {
        //                        var relatedItems = x.OpenedBooks.Where(z => z.BookId != y);

        //                        foreach (var z in relatedItems)
        //                        {
        //                            data.Add(new BookEntry()
        //                            {
        //                                BookID = (uint)y,
        //                                CoOpenedBookID = (uint)z.BookId,
        //                            });
        //                        }
        //                    });
        //                }
        //            }

        //            var trainData= mlContext.Data.LoadFromEnumerable(data);

        //            MatrixFactorizationTrainer.Options options = new MatrixFactorizationTrainer.Options();
        //            options.MatrixColumnIndexColumnName = nameof(BookEntry.BookID);
        //            options.MatrixRowIndexColumnName = nameof(BookEntry.CoOpenedBookID);
        //            options.LabelColumnName = "Label";
        //            options.LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass;
        //            options.Alpha = 0.01;
        //            options.Lambda = 0.025;
        //            // For better results use the following parameters
        //            options.NumberOfIterations = 100;
        //            options.C = 0.00001;

        //            var est = mlContext.Recommendation().Trainers.MatrixFactorization(options);

        //            model = est.Fit(trainData);
        //        }
        //    }

        //    var books = CurrentRepository.GetExceptById(id);

        //    var predictionResult = new List<Tuple<Book, float>>();

        //    foreach (var book in books)
        //    {

        //        var predictionengine = mlContext.Model.CreatePredictionEngine<BookEntry, CoBook_prediction>(model);
        //        var prediction = predictionengine.Predict(
        //                                 new BookEntry()
        //                                 {
        //                                     BookID = (uint)id,
        //                                     CoOpenedBookID = (uint)book.Id
        //                                 });


        //        predictionResult.Add(new Tuple<Book, float>(book, prediction.Score));
        //    }


        //    var finalResult = predictionResult.OrderByDescending(x => x.Item2).Select(x => x.Item1).Take(3).ToList();

        //    return Mapper.Map<List<BookDto>>(finalResult);

        //}

        //public async Task<List<object>> TrainBooksModel( CancellationToken cancellationToken=default)
        //{
        //    var bookResult= await CurrentRepository.GetPagedAsync(new BooksSearchObject() {PageSize=100000 }, cancellationToken);
        //    var books = bookResult.Items.ToList();

        //    List<object> recommendList = new List<object>();

        //    foreach (var book in books)
        //    {
        //        var recommendedBooks = Recommend(book.Id);

        //        var resultRecoomend = new RecommendedBooks()
        //        {
        //            bookId = book.Id,
        //            firstCobookId = recommendedBooks[0].Id,
        //            secondCobookId= recommendedBooks[1].Id,
        //            thirdCobookId= recommendedBooks[2].Id
        //        };
        //        recommendList.Add(resultRecoomend);
        //    }


        //    return  recommendList;
        //}


    }

    //public class CoBook_prediction
    //{
    //    public float Score { get; set; }
    //}

    //public class BookEntry
    //{
    //    [KeyType(count: 27)]
    //    public uint BookID { get; set; }

    //    [KeyType(count: 27)]
    //    public uint CoOpenedBookID { get; set; }

    //   public float Label { get; set; }
    //}

    //public class RecommendedBooks
    //{
    //    public int bookId { get; set; }
    //    public int firstCobookId { get; set; }
    //    public int secondCobookId { get; set; }
    //    public int thirdCobookId { get; set; }

    //}
}
