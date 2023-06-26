#!/bin/sh

set -e 

echo "run db migration"
/app/migrate -path /app/migration -database "postgresql://root:apw5vkg!JND4jhk*bkr@simple-bank.cejknk3keljc.us-east-2.rds.amazonaws.com:5432/simple_bank" -verbose up

echo "start the app"
exec "$@"