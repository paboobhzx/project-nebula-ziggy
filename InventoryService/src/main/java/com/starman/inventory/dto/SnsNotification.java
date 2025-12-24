package com.starman.inventory.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

@JsonIgnoreProperties(ignoreUnknown = true)
public record SnsNotification (
    @JsonProperty("Type") String type,
    @JsonProperty("MessageId") String messageId,
    @JsonProperty("TopicArn") String topicArn,
    @JsonProperty("Message") String message, //holds the inner json string
    @JsonProperty("Timestamp") String timestamp
) {}