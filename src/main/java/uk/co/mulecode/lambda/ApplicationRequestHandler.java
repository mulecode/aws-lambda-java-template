package uk.co.mulecode.lambda;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import lombok.extern.log4j.Log4j2;

import java.time.Instant;
import java.util.Map;

/**
 * When attached to SQS
 * import com.amazonaws.services.lambda.runtime.events.SQSEvent
 * implements RequestHandler<SQSEvent, String>
 * <p>
 * when JSON
 * implements RequestHandler<Map<String, String>, String>
 */
@Log4j2
public class ApplicationRequestHandler implements RequestHandler<Map<String, String>, String> {

  @Override
  public String handleRequest(Map<String, String> input, Context context) {

    log.info("Java lambda starting: {}", Instant.now());

    // get message from environment
    var profile = System.getenv("profile");
    log.info("profile: {}", profile);

    // message from event
    log.info("Reading: {}", input);

    // get messages from SQSEvent
//    input.getRecords().forEach(sqsMessage ->
//        log.info("Reading: {}", sqsMessage.getBody())
//    );

    return null;
  }

}
