# Oil and Gas Database Template Using Postgres-Postgis through Docker

The repository contains the Dockerfile built on top of `postgis/postgis` image and a `sql` file that creates the tables into the database. 


## Build the Image from  Docker file
To build the image

```
sudo docker build -t scuervo91/database_oil_gas:0.1 .
```

## Pull image from DockerHub


## Run the image

```
sudo docker run -v /host/path/to/directory:/var/lib/postgresql/data -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres POSTGRES_DB=geodb -p 5432:5432 --name database scuervo91/database_oil_gas 
```

