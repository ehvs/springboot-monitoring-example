FROM registry.access.redhat.com/ubi8/openjdk-17:1.14 AS builder
COPY /build/target/demo-0.0.1-SNAPSHOT.jar /home/root/restservicedemo/
ENV myworkspace /home/root/restservicedemo
WORKDIR ${myworkspace}
EXPOSE 8080
USER 9000:9000
ENTRYPOINT ["java", "-jar","demo-0.0.1-SNAPSHOT.jar"]
