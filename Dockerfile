# Stage 1: Build the application using Maven
FROM maven:3.9.6-eclipse-temurin-17 AS builder
...
RUN mvn clean package -DskipTests
WORKDIR /app

# Copy configuration files and source code directories
COPY pom.xml .
COPY src ./src

# Compile and package the code into a runnable JAR file
RUN mvn clean package -DskipTests

# Stage 2: Runtime image generation
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# Pull only the compiled target JAR from Stage 1
COPY --from=builder /app/target/*.jar ecommerce-app.jar

# Open up port 8080 for web server accessibility
EXPOSE 8080

# Configure container startup execution parameters
ENTRYPOINT ["java", "-jar", "ecommerce-app.jar"]

