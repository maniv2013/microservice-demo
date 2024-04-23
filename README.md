# micro services
This is an application for micro service demo. 
This application runs a SPA UI both web and mobile version, all modules are segregated in micro service architecture. Text search (FTS) querying capabilities.

It uses Couchbase Server together with the [Spring Boot] web framework for [Java], [Swagger] for API documentation, [React] and [native].

The applicatin is a  planner that allows the user to search for and select a cottage and route (including the return road trip) based on pickup location and dates.
Cottage location selection is done dynamically using and autocomplete box bound to N1QL queries on the server side. After selecting a date, it then searches for applicable cottages from a previously populated database. 

## Prerequisites
To download the application you can either download [the archive](https://github.com/maniv2013/microservice-demo/archive/refs/heads/main.zip) or clone the repository:

 gh clone https://github.com/maniv2013/microservice-demo.git

<!-- If you want to run the application from your IDE rather than from the command line you also need your IDE set up to
work with maven-based projects. We recommend running IntelliJ IDEA, but Eclipse or Netbeans will also work. -->

We recommend running the application with Docker, which starts up all components for you,
but you can also run it in a Mix-and-Match style, which we'll decribe below.

You will need [Docker](https://docs.docker.com/get-docker/) installed on your machine in order to run this application as we have defined a [_Dockerfile_](Dockerfile) and a [_docker-compose.yml_](docker-compose.yml) to run Couchbase Server 7.0.0 beta, the front-end [React app](https://github.com/maniv2013/kodaicottageservices.git) and the Java REST API.

To launch the full application, simply run this command from a terminal:

    docker-compose up

> **_NOTE:_** When you run the application for the first time, it will pull/build the relevant docker images, so it might take a bit of time.

This will start the Java backend, Couchbase Server 7.0.0-beta and the Vue frontend app.

```
❯ docker-compose up
...
Creating couchbase-sandbox-7.0.0-beta ... done



You should then be able to browse the UI, search for the cottages and get trip route information.

To end the application press <kbd>Control</kbd>+<kbd>C</kbd> in the terminal
and wait for docker-compose to gracefully stop your containers.

## Mix and match services
Instead of running all services, you can start any combination of `backend`,
`frontend`, `db` via docker, and take responsibility for starting the other
services yourself.

As the provided `docker-compose.yml` sets up dependencies between the services,
to make startup as smooth and automatic as possible, we also provide an
alternative `mix-and-match.yml`. We'll look at a few useful scenarios here.

### Bring your own database

If you wish to run this application against your own configuration of Couchbase
Server, you will need version 7.0.0 beta or later with the `kodai-cottage-storage`
bucket setup.

> **_NOTE:_** If you are not using Docker to start up the API server, or the
> provided wrapper `wait-for-couchbase.sh`, you will need to create a full text
> search index on demo-storage bucket called 'demo-index'. You can do this
> via the following command:

    curl --fail -s -u <username>:<password> -X PUT \
            http://<host>:8094/api/index/demo-index \
            -H 'cache-control: no-cache' \
            -H 'content-type: application/json' \
            -d @fts-demo-index.json

With a running Couchbase Server, you can pass the database details in:

    CB_HOST=<ip> CB_USER=<username> CB_PSWD=<password> docker-compose -f mix-and-match.yml up backend frontend

The Docker image will run the same checks as usual, and also create the
`demo-index` if it does not already exist.

### Running the Java API application manually

You may want to run the Java application yourself, to make rapid changes to it,
and try out the features of the Couchbase API, without having to re-build the Docker
image. You may still use Docker to run the Database and Frontend components if desired.

Please ensure that you have the following before proceeding.

* Java 8 or later (Java 11 recommended)
* Maven 3 or later

Install the dependencies:

    mvn clean install

The first time you run against a new database image, you may want to use the provided
`wait-for-couchbase.sh` wrapper to ensure that all indexes are created.
For example, using the Docker image provided:

    docker-compose -f mix-and-match.yml up db

    export CB_HOST=localhost CB_USER=<user> CB_PSWD=<password>
    ./wait-for-couchbase.sh echo "Couchbase is ready!"

    mvn spring-boot:run -Dspring-boot.run.arguments="--storage.host=$CB_HOST storage.username=$CB_USER storage.password=$CB_PSWD"

If you already have an existing Couchbase server running and correctly configured, you might run:

    mvn spring-boot:run -Dspring-boot.run.arguments="--storage.host=localhost storage.username=<user> storage.password=<password>"

Finally, if you want to see how the sample frontend React application works with your changes,
run it with:

    docker-compose -f mix-and-match.yml up frontend
### Running the front-end manually

To run the frontend components manually without Docker, follow the guide
[here](https://github.com/maniv2013/microservice-demo/archive/refs/heads/main.zip)

## REST API reference

I've integrated Swagger/OpenApi version 3 documentation which can be accessed on the backend at `http://localhost:8080/apidocs`

[Couchbase Server]: https://www.couchbase.com/
[Java SDK]: https://docs.couchbase.com/java-sdk/current/hello-world/overview.html
[Spring Boot]: https://spring.io/projects/spring-boot
[Java]: https://www.java.com/en/
[Swagger]: https://swagger.io/resources/open-api/
[React]: https://reactnative.dev/docs/getting-started
