using Microsoft.AspNetCore.Mvc;
using OrderService.Models;
using Amazon.SimpleNotificationService;
using Amazon.SimpleNotificationService.Model;
using System.Threading.Tasks;
using System.Text.Json;


namespace OrderService.Controllers {
    [ApiController]
    [Route("api/[controller]")]
    
    public class OrdersController : ControllerBase {   
        private readonly IAmazonSimpleNotificationService  _snsClient;  
        public OrdersController (IAmazonSimpleNotificationService snsClient){
            _snsClient = snsClient;
        }
        

        [HttpPost]
        public async Task<IActionResult> CreateOrder(OrderRequest order){
            var orderJson = JsonSerializer.Serialize(order);
            var request = new PublishRequest
            {
                TopicArn = "arn:aws:sns:us-east-1:288854271409:starman-orders-event-topic",
                Message = orderJson,
                Subject = "New order created"
                
            };

            await _snsClient.PublishAsync(request);
            return Ok(new { message = "Order Broadcasted to SNS", orderId = order.OrderId});
        }
        
    



    }
}
    

