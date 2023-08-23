using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using RabbitMQ.Client;
using System.Text;

namespace Main.Api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class NotificationController : ControllerBase
    {
        [HttpPost("SendNotification")]
        public async Task<IActionResult> SendNotification(NotificationUpsertDto notification)
        {
            if(notification == null) 
                return BadRequest("Cann't send null object");

            if(notification.Id >0   && notification.Id < 0)
                return BadRequest("Id must be 0");

            if(notification.Title == null || notification.Title.Length== 0)
                return BadRequest("Title is mandatory");

            if (notification.UserId <= 0)
                return BadRequest("UserId must be greater than 0");



            //var factory = new ConnectionFactory { HostName = "rmq_host", Port = 5672 };
            var factory = new ConnectionFactory { HostName = "localhost" };
            using var connection = factory.CreateConnection();
            using var channel = connection.CreateModel();

            channel.QueueDeclare(queue: "notification",
                                 durable: false,
                                 exclusive: false,
                                 autoDelete: true,
                                 arguments: null);


            var json = JsonConvert.SerializeObject(notification);

            var body = Encoding.UTF8.GetBytes(json);

            channel.BasicPublish(exchange: string.Empty,
                                 routingKey: "notification",

                                 body: body);

            return  Ok(notification);
        }
    }
}
