
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


        public UnitOfWork(
            DatabaseContext databaseContext,
            ICountriesRepository countriesRepository,
            ICitiesRepository citiesRepository
,
            IPhotosRepository photosRepository,
            IBooksRepository booksRepository,
            IQuotesRepository quotesRepository)
        {
            _databaseContext = databaseContext;

            CountriesRepository = countriesRepository;
            CitiesRepository = citiesRepository;
            PhotosRepository = photosRepository;
            BooksRepository = booksRepository;
            QuotesRepository = quotesRepository;
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
