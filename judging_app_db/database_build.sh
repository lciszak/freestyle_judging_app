#!/bin/bash

PS3='What do you want to build: '
options=("Schema" "Data" "Quit")


select option in "${options[@]}"; do

    case "$REPLY" in 

        1) psql mcrest -h localhost -U fsrest fsrest < init/00_schema.sql ;;

        2) psql fsrest -h localhost -U mcrest fsrest < init/01_data.sql ;;

        3) break ;;

    esac

done
