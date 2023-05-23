FROM registry.access.redhat.com/ubi8/openjdk-17:1.14 AS builder
COPY target/RestServiceDemo-1.0.0-SNAPSHOT.jar /home/root/restservicedemo/
ENV myworkspace /home/root/restservicedemo
WORKDIR ${myworkspace}
EXPOSE 8080
USER 9000:9000
ENTRYPOINT ["java", "-jar","RestServiceDemo-1.0.0-SNAPSHOT.jar"]
