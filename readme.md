# Oil and Gas Database Template Using Postgres-Postgis through Docker

The repository contains the Dockerfile built on top of `postgis/postgis` image and a `sql` file that creates the tables into the database. 


## Build the Image from  Docker file
To build the image

```
sudo docker build -t image_name:tag .
```
```
sudo docker build -t database_oil_gas:latest .
```


## Pull image from DockerHub

Docker hub automatically builds the image from this repository, being the master branch the `latest` version of the image and the `GitHub Tagged Releases` are built with the same tag.

### latest
```
docker pull scuervo91/oilbase:latest
```
or

### Tagged
```
docker pull scuervo91/oilbase:v0.1
```

## Run the image

Postgres Env Variables must be set to access the database

### Env Variables
POSTGRES_USER: Username to access
POSTGRES_PASSWORD: Password to acess
POSTGRES_DB: Database name to create the tables and structures

### Persisting the data in a Volume
```
sudo docker run --rm -v /host/path/to/directory:/var/lib/postgresql/data -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=geodb -p 5432:5432 --name database scuervo91/oilbase:latest 
```

### Without Persisting the data
```
sudo docker run --rm -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=db -p 5432:5432 --rm --name database scuervo91/oilbase:latest 
```
