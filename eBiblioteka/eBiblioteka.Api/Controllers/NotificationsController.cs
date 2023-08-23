using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure.Interfaces;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;

namespace eBiblioteka.Api.Controllers
{
    public class NotificationsController : BaseCrudController<NotificationDto, NotificationUpsertDto, NotificationsSearchObject, INotificationsService>
    {
        public NotificationsController(INotificationsService service, ILogger<NotificationsController> logger) : base(service, logger)
        {
        }

        [Authorize]
        [HttpPut("MakeRead/{notifId}")]
        public async Task<IActionResult> MakeRead(int notifId, CancellationToken cancellationToken=default)
        {
            try
            {
               await Service.ReadNotification(notifId, cancellationToken);
                return Ok();
            }
            catch (Exception e)
            {

                throw new Exception(e.Message,e?.InnerException);
            }
        }
        
    }
}
