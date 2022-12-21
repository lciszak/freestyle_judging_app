FROM postgres:15.1-alpine

COPY init/00_create_schema.sql /docker-entrypoint-initdb.d/
COPY init/01_initial_load.sql /docker-entrypoint-initdb.d/
#COPY init/02_chop.sql /docker-entrypoint-initdb.d/
#COPY init/03_atc.sql /docker-entrypoint-initdb.d/
#COPY init/04_icd_de_en.sql /docker-entrypoint-initdb.d/

