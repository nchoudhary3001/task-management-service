# Stage 1: Use an image with a package manager to install wget
FROM debian:bullseye-slim as wget-installer
RUN apt-get update && apt-get install -y wget

# Stage 2: Use your OpenJDK base image
FROM openjdk:17-oracle

# Copy wget from the previous stage
COPY --from=wget-installer /usr/bin/wget /usr/bin/wget


ARG DEPENDENCY=target/dependency

ENV SPRING_PROFILES_ACTIVE=${SPRING_PROFILES_ACTIVE}
ENV SPRING_PROFILES_SERVER_TYPE=${SPRING_PROFILES_SERVER_TYPE}
ENV APP_DOMAIN=${APP_DOMAIN}
ENV DOMAIN=${DOMAIN}
ENV KEYVAULTSERVICE_URL=${KEYVAULTSERVICE_URL}
ENV SPRING_APPLICATION_NAME=InventoryManagementService

COPY ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY ${DEPENDENCY}/META-INF /app/META-INF
COPY ${DEPENDENCY}/BOOT-INF/classes /app

RUN adduser --uid 10000 rails
USER root
RUN chown -R 10000:10000 /app
USER rails

EXPOSE 8080
HEALTHCHECK CMD curl --fail http://localhost:8080/actuator/health || exit 1
ENTRYPOINT java $JAVA_OPTS -cp app:app/lib/* com.bizongo.task_management_service.TaskManagementServiceApplication