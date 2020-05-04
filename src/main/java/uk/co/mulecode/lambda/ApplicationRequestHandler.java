package uk.co.mulecode.lambda;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import lombok.extern.log4j.Log4j2;

import java.time.Instant;

@Log4j2
public class ApplicationRequestHandler implements RequestHandler<Object, Object> {

  @Override
  public Object handleRequest(Object input, Context context) {

    log.info("Java lambda starting: {}", Instant.now());

    return null;
  }

}
