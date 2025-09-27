# Stage 1: Build with Java 8

FROM maven:3.9.6-eclipse-temurin-8 AS build

WORKDIR /app

# Copy all code (parent pom + modules)
COPY . .

# Build the project (skip tests to speed up)
RUN mvn -f pom.xml clean package -DskipTests

# Stage 2: Run with Tomcat 8 + JDK 8
FROM tomcat:8.5-jdk8

WORKDIR /usr/local/tomcat/webapps/

# Copy WAR file from the module that produces it
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/spring-boot-rest-example.war

# Expose default Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
