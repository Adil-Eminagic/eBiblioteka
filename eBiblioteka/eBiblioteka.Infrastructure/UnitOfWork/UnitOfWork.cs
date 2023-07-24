
using eBiblioteka.Infrastructure.Interfaces;
using Microsoft.EntityFrameworkCore.Storage;

namespace eBiblioteka.Infrastructure
{
    public class UnitOfWork : IUnitOfWork
    {
        private readonly DatabaseContext _databaseContext;

        public readonly ICountriesRepository CountriesRepository;
        public readonly ICitiesRepository CitiesRepository;
        public readonly IPhotosRepository PhotosRepository;
        public readonly IBooksRepository BooksRepository;
        public readonly IQuotesRepository QuotesRepository;
        public readonly IGenresRepository GenresRepository;
        public readonly IAuthorsRepository AuthorsRepository;
        public readonly IUserBooksRepository UserBooksRepository;
        public readonly IUsersRepository UsersRepository;
        public readonly IBookGenresRepository BookGenresRepository;
        public readonly IRatingsRepository RatingsRepository;
        public readonly IGendersRepository GendersRepository;
        public readonly IRolesRepository RolesRepository;
        public readonly IQuizsRepository QuizsRepository;
        public readonly IQuestionsRepository QuestionsRepository;
        public readonly IAnswersRepository AnswersRepository;


        public UnitOfWork(
            DatabaseContext databaseContext,
            ICountriesRepository countriesRepository,
            ICitiesRepository citiesRepository,
            IPhotosRepository photosRepository,
            IBooksRepository booksRepository,
            IQuotesRepository quotesRepository,
            IGenresRepository genresRepository,
            IAuthorsRepository authorsRepository,
            IUserBooksRepository userBooksRepository,
            IUsersRepository usersRepository,
            IBookGenresRepository bookGenresRepository,
            IRatingsRepository ratingsRepository,
            IGendersRepository gendersRepository,
            IRolesRepository rolesRepository,
            IQuizsRepository quizsRepository,
            IQuestionsRepository questionsRepository,
            IAnswersRepository answersRepository)
        {
            _databaseContext = databaseContext;

            CountriesRepository = countriesRepository;
            CitiesRepository = citiesRepository;
            PhotosRepository = photosRepository;
            BooksRepository = booksRepository;
            QuotesRepository = quotesRepository;
            GenresRepository = genresRepository;
            AuthorsRepository = authorsRepository;
            UserBooksRepository = userBooksRepository;
            UsersRepository = usersRepository;
            BookGenresRepository = bookGenresRepository;
            RatingsRepository = ratingsRepository;
            GendersRepository = gendersRepository;
            RolesRepository = rolesRepository;
            QuizsRepository = quizsRepository;
            QuestionsRepository = questionsRepository;
            AnswersRepository = answersRepository;
        }

        public async Task<IDbContextTransaction> BeginTransactionAsync(CancellationToken cancellationToken = default)
        {
            return await _databaseContext.Database.BeginTransactionAsync(cancellationToken);
        }

        public async Task CommitTransactionAsync(CancellationToken cancellationToken = default)
        {
            await _databaseContext.Database.CommitTransactionAsync(cancellationToken);
        }

        public async Task RollbackTransactionAsync(CancellationToken cancellationToken = default)
        {
            await _databaseContext.Database.RollbackTransactionAsync(cancellationToken);
        }

        public async Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
        {
            return await _databaseContext.SaveChangesAsync(cancellationToken);
        }
    }
}
