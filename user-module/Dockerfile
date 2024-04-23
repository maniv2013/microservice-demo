# Start with a base image containing Java runtime
FROM openjdk:11-jdk

# Add Maintainer Info
LABEL maintainer="mani vincent"

# Add a volume pointing to /tmp
WORKDIR /app

#COPY mvnw pom.xml ./
RUN mkdir -p /usr/share/man/man1
RUN apt-get update && apt-get install -y maven jq curl



#ADD . \app
COPY ./ ./app

# Install project dependencies and generate jar file
RUN mvn -f ./app/user-module/pom.xml clean package

# Make port 8091 available to the world outside this container
EXPOSE 9090

# The application's jar file
ARG JAR_FILE=./user-module/target/usermodule-0.0.1-SNAPSHOT.jar

# Add the application's jar to the container
ADD ${JAR_FILE} usermodule.jar


# Run the jar file
#ENTRYPOINT ["../persistentlayer/wait-for-couchbase.sh","java","-Djava.security.egd=file:/dev/./urandom","-jar","/usermodule.jar"]
#ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/usermodule.jar"]
ENTRYPOINT ["java","-jar","usermodule.jar"]
