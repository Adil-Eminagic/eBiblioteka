﻿
using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace eBiblioteka.Infrastructure
{
    public class BookGenresRepository : BaseRepository<BookGenre, int, BookGenresSearchObject>, IBookGenresRepository
    {
        public BookGenresRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }

        public async override Task<BookGenre?> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            return await DbSet.Include(c=>c.Genre).AsNoTracking().Include(c=>c.Book).FirstOrDefaultAsync( c=>c.Id==id, cancellationToken);
        }

        public async override Task<PagedList<BookGenre>> GetPagedAsync(BookGenresSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Where(c=> searchObject.BookId== null || searchObject.BookId== c.BookId)
                .Where(c=> searchObject.GenreId== null || searchObject.GenreId == c.GenreId)
                .Include(c=>c.Genre).Include(c=>c.Book)
                .ToPagedListAsync(searchObject, cancellationToken);
        }
    }
}
