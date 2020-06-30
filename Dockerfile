FROM postgis/postgis

COPY . /docker-entrypoint-initdb.d/
