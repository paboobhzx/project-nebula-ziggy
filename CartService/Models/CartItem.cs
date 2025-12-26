namespace CartService.Models;
using Amazon.DynamoDBv2.DataModel;

[DynamoDBTable("starman-cart-table")]
public class CartItem { 
    [DynamoDBHashKey("UserName")]
    public string UserName { get ; set;} = string.Empty;
    [DynamoDBRangeKey("ProductId")]
    public string ProductId {get ; set;} = string.Empty;
    [DynamoDBProperty]
    public int quantity { get; set;}
    [DynamoDBProperty("expiry_time")]
    public long ExpiryTime { get; set;}

}