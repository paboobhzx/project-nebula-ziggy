package com.starman.inventory.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.math.BigDecimal;
import java.util.UUID;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

public record OrderEvent(
    @JsonProperty("OrderId") UUID orderId,
    @JsonProperty("ProductId")  String productId,
    @JsonProperty("Quantity") int quantity,
    @JsonProperty("Price") BigDecimal price,
    @JsonProperty("CustomerId") String customerId
  
) {}