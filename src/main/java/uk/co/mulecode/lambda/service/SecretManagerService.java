package uk.co.mulecode.lambda.service;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.secretsmanager.AWSSecretsManager;
import com.amazonaws.services.secretsmanager.AWSSecretsManagerClientBuilder;
import com.amazonaws.services.secretsmanager.model.GetSecretValueRequest;
import lombok.Setter;
import lombok.extern.log4j.Log4j2;

import java.util.Map;
import java.util.Objects;

import static java.util.Objects.nonNull;
import static java.util.Objects.requireNonNull;
import static uk.co.mulecode.lambda.utils.JsonUtils.toMap;

@Log4j2
public class SecretManagerService {

  private Map<String, String> secrets;

  @Setter
  private Regions REGION = Regions.EU_WEST_2;

  public SecretManagerService(final String secretName) {
    load(secretName);
  }

  private AWSSecretsManager getAwsSecretsManager() {
    return AWSSecretsManagerClientBuilder.standard()
        .withRegion(REGION)
        .build();
  }

  private void load(final String secretName) {

    GetSecretValueRequest getSecretValueRequest = new GetSecretValueRequest()
        .withSecretId(secretName);

    String secretString = getAwsSecretsManager()
        .getSecretValue(getSecretValueRequest)
        .getSecretString();

    this.secrets = toMap(secretString);

    log.info("Secrets {} loaded {}", secretName, nonNull(secrets));
  }

  public String getSecret(final String key) {

    requireNonNull(secrets);

    return secrets.get(key);
  }
}
