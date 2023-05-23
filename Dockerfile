####
FROM registry.access.redhat.com/ubi8/openjdk-17:1.14 AS builder
# Build dependency offline to streamline build
COPY pom.xml .
RUN mvn dependency:go-offline

COPY src src
RUN mvn package -Dmaven.test.skip=true 
# compute the created jar name and put it in a known location to copy to the next layer.
# If the user changes pom.xml to have a different version, or artifactId, this will find the jar 
RUN grep version /home/jboss/target/maven-archiver/pom.properties | cut -d '=' -f2 >.env-version
RUN grep artifactId /home/jboss/target/maven-archiver/pom.properties | cut -d '=' -f2 >.env-id
RUN mv /home/jboss/target/$(cat .env-id)-$(cat .env-version).jar /home/jboss/target/export-run-artifact.jar

FROM registry.access.redhat.com/ubi8/openjdk-17-runtime:1.15
COPY --from=builder /home/jboss/target/export-run-artifact.jar  /deployments/export-run-artifact.jar

COPY /build/target/demo-0.0.1-SNAPSHOT.jar /home/root/restservicedemo/
ENV myworkspace /home/root/restservicedemo
WORKDIR ${myworkspace}
EXPOSE 8080
USER 9000:9000
ENTRYPOINT ["java", "-jar","demo-0.0.1-SNAPSHOT.jar"]
