#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0]
then
    echo "Please run this script as super user"
    exit 1
else
    echo "Running this script as super user"
fi

./mysql.sh
./backend.sh
./frontend.sh