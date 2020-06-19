FROM postgis/postgis

COPY z_init.sql /docker-entrypoint-initdb.d/