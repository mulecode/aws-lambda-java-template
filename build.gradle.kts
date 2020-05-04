plugins {
    java
    id("idea")
    id("maven-publish")
}

java {
    sourceCompatibility = JavaVersion.VERSION_1_8
    targetCompatibility = JavaVersion.VERSION_1_8
}

repositories {
    mavenLocal()
    mavenCentral()
}

group = "uk.co.mulecode.lambda"

tasks {
    register<Zip>("buildZip") {
        from(compileJava)
        from(processResources)
        into("lib") {
            from(configurations.runtimeClasspath)
        }
    }
}

dependencies {

    compileOnly("org.projectlombok:lombok:1.18.12")
    annotationProcessor("org.projectlombok:lombok:1.18.12")
    testAnnotationProcessor("org.projectlombok:lombok:1.18.12")

    implementation("com.amazonaws:aws-lambda-java-core:1.2.0")
    implementation("com.amazonaws:aws-java-sdk-secretsmanager:1.11.688")

    implementation("com.amazonaws:aws-lambda-java-log4j2:1.1.1")
    implementation("org.apache.logging.log4j:log4j-core:2.8.2")
    implementation("org.apache.logging.log4j:log4j-api:2.8.2")

    implementation("com.fasterxml.jackson.module:jackson-module-parameter-names:2.11.0")
    implementation("com.fasterxml.jackson.core:jackson-databind:2.11.0")
    implementation("com.fasterxml.jackson.datatype:jackson-datatype-jdk8:2.11.0")
    implementation("com.fasterxml.jackson.datatype:jackson-datatype-jsr310:2.11.0")
    implementation("com.fasterxml.jackson.jaxrs:jackson-jaxrs-json-provider:2.11.0")
}