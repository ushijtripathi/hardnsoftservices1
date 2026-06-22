# Stage 1: Build the application using Maven and JDK 8
FROM maven:3.8.6-openjdk-8-slim AS build
WORKDIR /app

# Copy the pom.xml and download dependencies (for caching)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy the source code and build the WAR file
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Run the application using Tomcat 9 (compatible with Java EE 8)
FROM tomcat:9.0-jre8-slim

# Remove default Tomcat applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the built WAR file to Tomcat's webapps directory as ROOT.war
# This ensures the app is served at the root path (/)
COPY --from=build /app/target/mavenproject2-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

# Expose port 8080 (Render automatically detects this)
EXPOSE 8080

# Start Tomcat server
CMD ["catalina.sh", "run"]
