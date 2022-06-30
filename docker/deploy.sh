#!/bin/bash
docker-compose -f docker-compose-postgres.yml -p sgd_postgres up -d
docker-compose -f docker-compose.yml -p sgd up -d