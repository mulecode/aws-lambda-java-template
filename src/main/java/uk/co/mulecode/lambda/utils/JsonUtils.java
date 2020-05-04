package uk.co.mulecode.lambda.utils;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.Map;

public final class JsonUtils {

  private final static ObjectMapper objectMapper = new ObjectMapper();

  public static String toJson(Object value) {
    try {
      return objectMapper.writeValueAsString(value);
    } catch (JsonProcessingException e) {
      throw new RuntimeException("Error processing object to json", e);
    }
  }

  public static <T> T toObject(String value, Class<T> type) {
    try {
      return objectMapper.readValue(value, type);
    } catch (JsonProcessingException e) {
      throw new RuntimeException("Error processing string to Object: " + type.getName(), e);
    }
  }

  public static Map<String, String> toMap(String value) {
    try {
      return objectMapper.readValue(value, new TypeReference<Map<String, String>>() {
      });
    } catch (Exception e) {
      throw new RuntimeException("Error processing string to Map", e);
    }
  }

}
