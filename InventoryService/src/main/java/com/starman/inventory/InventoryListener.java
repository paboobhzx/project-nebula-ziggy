package com.starman.inventory;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.starman.inventory.dto.OrderEvent;
import com.starman.inventory.dto.SnsNotification;
import com.starman.inventory.model.InventoryItem;
import com.starman.inventory.repository.InventoryRepository;
import io.awspring.cloud.sqs.annotation.SqsListener;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class InventoryListener {

    private static final Logger logger = LoggerFactory.getLogger(InventoryListener.class);
    private final ObjectMapper objectMapper;
    private final InventoryRepository inventoryRepository;

    public InventoryListener(ObjectMapper objectMapper, InventoryRepository inventoryRepository) {
        this.objectMapper = objectMapper;
        this.inventoryRepository = inventoryRepository;
    }

    @Transactional
    @SqsListener("${inventory.queue.url}")
    public void listen(String rawMessage) {
        logger.info("📦 INVENTORY RECEIVED ORDER: " + rawMessage);
        try {
            // 1. Parse Outer SNS Envelope
            SnsNotification notification = objectMapper.readValue(rawMessage, SnsNotification.class);
            
            
            OrderEvent order = objectMapper.readValue(notification.message(), OrderEvent.class);

            logger.info("⚡ PROCESSING ORDER: " + order.productId());

// 2. Use order.productId() to find the item
            InventoryItem item = inventoryRepository.findByProductId(order.productId())
                 .orElseThrow(() -> new RuntimeException("Product not found: " + order.productId()));

            // 3. Update quantity: item uses Lombok (get/set), order is a Record (direct name)
            int newQuantity = item.getQuantity() - order.quantity(); 
            item.setQuantity(newQuantity);

            inventoryRepository.save(item);

        } catch (JsonProcessingException e) {
            logger.error("❌ Failed to parse JSON: " + e.getMessage());
        } catch (Exception e) {
            logger.error("❌ Error processing order: " + e.getMessage());
        }
    }
}