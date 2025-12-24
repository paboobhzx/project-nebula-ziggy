package com.starman.inventory;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.starman.inventory.dto.OrderEvent;
import com.starman.inventory.dto.SnsNotification;
import io.awspring.cloud.sqs.annotation.SqsListener;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import com.starman.inventory.dto.OrderEvent;
import com.starman.inventory.dto.SnsNotification;
import com.starman.inventory.model.Inventory;
import com.starman.inventory.repository.InventoryRepository;
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
    public void Listen(String rawMessage){
        logger.info("📦 INVENTORY RECEIVED ORDER: " + rawMessage);
        try {
            //updating SNS envelope
            SnsNotification notification = objectMapper.readValue(rawMessage, SnsNotification.class);
            //parsing innner json
            OrderEvent order = objectMapper.readValue(notification.message(), OrderEvent.class);
            logger.info("⚡ PROCESSING ORDER: " + order.orderId());
            //find product and reduce stock - using UPSERT
            Inventory item = inventoryRepository.findByProductId(order.productId())
                    .orElse(new Inventory(null, order.productId(), 100));
            item.setQuantity(item.getQuantity() - order.quantity());
            inventoryRepository.save(item);


        } catch(JsonProcessingException e) {
            logger.error("❌ Failed to parse message: " + e.getMessage());
        }

    }


}