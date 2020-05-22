package uk.co.mulecode.lambda;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
//import com.amazonaws.services.lambda.runtime.events.SQSEvent;
import lombok.extern.log4j.Log4j2;

import java.time.Instant;

/**
 * When attached to SQS
 * implements RequestHandler<SQSEvent, String>
 * <p>
 * When scheduled by cron
 * implements RequestHandler<String, String>
 * when JSON
 * implements RequestHandler<Map<String,String>, String>
 */
@Log4j2
public class ApplicationRequestHandler implements RequestHandler<String, String> {

  @Override
  public String handleRequest(String input, Context context) {

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
