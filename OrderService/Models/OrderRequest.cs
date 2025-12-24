namespace OrderService.Models
{
    public class OrderRequest {
        public Guid OrderId { get; set; } = Guid.NewGuid();
        public string  ProductId { get; set; } = string.Empty;
        public int Quantity { get; set; }
        public decimal Price { get; set; }
        public string  CustomerId { get; set; } = string.Empty;

    }
}