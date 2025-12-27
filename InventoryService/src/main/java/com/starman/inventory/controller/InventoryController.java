package com.starman.inventory.controller;

import com.starman.inventory.model.InventoryItem;
import com.starman.inventory.repository.InventoryRepository;

import org.springframework.beans.factory.annotation.Autowired; 
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/inventory")
@CrossOrigin(origins = "*")
public class InventoryController { 
    @Autowired 
    private InventoryRepository inventoryRepository;

    @GetMapping
    public List<InventoryItem> getAllItems() { 
        return inventoryRepository.findAll();
    }
    
    @PostMapping
    public InventoryItem addItem(@RequestBody InventoryItem item) { 
        return inventoryRepository.save(item);
    }
    @GetMapping("/health")
    public ResponseEntity<String> health() { 
        return ResponseEntity.ok("Inventory SErvice is Healthy");
    }
}