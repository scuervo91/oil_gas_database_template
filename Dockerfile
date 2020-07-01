FROM postgis/postgis

COPY ./init_files/ /docker-entrypoint-initdb.d/
