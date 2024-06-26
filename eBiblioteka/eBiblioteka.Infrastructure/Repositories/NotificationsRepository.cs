﻿
using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;


namespace eBiblioteka.Infrastructure
{
    public class NotificationsRepository : BaseRepository<Notification, int, NotificationsSearchObject>, INotificationsRepository
    {
        public NotificationsRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }

        public override async Task<PagedList<Notification>> GetPagedAsync(NotificationsSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet
                .Where(c=> searchObject.Title == null || c.Title.ToLower().Contains(searchObject.Title.ToLower()))
                .Where(c=> searchObject.IsRead==null || c.IsRead==searchObject.IsRead)
                .Where(c=> searchObject.UserId==c.UserId || searchObject.UserId ==null)
                .OrderByDescending(c=>c.Id)
            .ToPagedListAsync(searchObject, cancellationToken);
        }

        public async override Task<ReportInfo<Notification>> GetCountAsync(NotificationsSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet
                 .Where(c => searchObject.Title == null || c.Title.ToLower().Contains(searchObject.Title.ToLower()))
                 .Where(c => searchObject.IsRead == null || c.IsRead == searchObject.IsRead)
                 .Where(c => searchObject.UserId == c.UserId || searchObject.UserId == null)
             .ToReportInfoAsync(searchObject, cancellationToken);
        }

    }
}
