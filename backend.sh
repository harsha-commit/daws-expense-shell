#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTNAME=$(echo $0 | cut -d '.' -f 1)
LOGFILE="/tmp/$SCRIPTNAME-$TIMESTAMP.log"

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo "$2 ... FAILED"
    else
        echo "$2 ... SUCCESS"
}

if [ $USERID -ne 0 ]
then
    echo "Please run this script as super user"
    exit 1
else
    echo "Running this script as super user"
fi

dnf module disable nodejs -y &>> $LOGFILE
VALIDATE $? "Disabling NodeJS"

dnf module enable nodejs:20 -y &>> $LOGFILE
VALIDATE $? "Enabling NodeJS:20"

dnf install nodejs -y &>> $LOGFILE
VALIDATE $? "Installing NodeJS:20"

useradd expense &>> $LOGFILE
VALIDATE $? "Adding User: expense"

mkdir /app
curl -o /tmp/backend.zip "https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip"
cd /app
unzip /tmp/backend.zip
npm install

