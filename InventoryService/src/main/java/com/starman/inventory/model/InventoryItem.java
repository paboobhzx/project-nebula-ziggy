package com.starman.inventory.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import lombok.*;


@Entity
@Table(name = "inventory")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class InventoryItem {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @JsonProperty("productId") 
    @Column(name = "product_id")
    private String productId;

    @JsonProperty("name")
    @Column(name = "name")
    private String name;

    @JsonProperty("category")
    @Column(name = "category")
    private String category;

    @JsonProperty("price")
    @Column(name = "price")
    private Double price;

    @JsonProperty("quantity")
    @Column(name = "quantity")
    private Integer quantity;
}