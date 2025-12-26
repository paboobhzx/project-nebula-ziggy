using Microsoft.AspNetCore.Mvc;
using Amazon.DynamoDBv2.DataModel;
using CartService.Models;

namespace CartService.Controllers 
{
    [ApiController]
    [Route("api/[controller]")]
    public class CartController : ControllerBase 
    {
        private readonly IDynamoDBContext _context;
        public CartController(IDynamoDBContext context)
        {
            _context = context;
        }
        [HttpPost]
        public async Task<IActionResult> AddItem([FromBody] CartItem item)
        {
            //Set TTL to 24 hours
            item.ExpiryTime = DateTimeOffset.UtcNow.AddHours(24).ToUnixTimeSeconds();
            await _context.SaveAsync(item);
            return Ok(new { message = "Item added to cart", item});
        }
        //Get all items for a specific user
        // GET api/cart{userName}
        [HttpGet("{userName}")]
        public async Task<IActionResult> GetCart(string userName)
        {
            var conditions = new List<ScanCondition>
            {
                new ScanCondition("UserName", Amazon.DynamoDBv2.DocumentModel.ScanOperator.Equal, userName)
            };
            //In real-world high-scale app i would use QueryAsync instead of ScqanAsync for performance, but
            //since its a small project with small data, scan works fine
            var items = await _context.ScanAsync<CartItem>(conditions).GetRemainingAsync();
            return Ok(items);
        }

        //DELETE api/cart/{userName}/{productId}
        [HttpDelete("{userName}/{productId}")]
        public async Task<IActionResult> RemoveItem(string userName, string productId){
            await _context.DeleteAsync<CartItem>(userName, productId);
            return Ok(new { message = "Item removed from cart"});
        }

    }
}