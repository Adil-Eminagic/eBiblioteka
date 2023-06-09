﻿
using eBiblioteka.Core;

namespace eBiblioteka.Infrastructure.Interfaces
{
    public interface IBooksRepository : IBaseRepository<Book, int, BooksSearchObject>
    {
        Task<IEnumerable<Book>> GetByAuthorIdAsync(int authorId, CancellationToken cancellationToken);
    }
}
