#!/bin/bash

# Getting User ID using id command
# User ID of super user is 0
USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTNAME=$(echo $0 | cut -d '.' -f 1)
LOGFILE="/tmp/$SCRIPTNAME-$TIMESTAMP.log"

# Function to check if package is installed correctly, else quit
# Because this can be re-used for other packages, it is made to a function
VALIDATE(){
    if [ $? -ne 0 ]
    then
        echo "$2...FAILED"
    else
        echo "$2...SUCCESS"
    fi
}

# Check if the user is root user or not
if [ $USERID -ne 0 ]
then
    echo "Please run this script as super user"
    exit 1
fi

# Check if the package is already installed
dnf list installed mysql-server &>> $LOGFILE

if [ $? -eq 0 ]
then
    echo "MySQL Server package is already installed...SKIPPED"
else
    dnf install mysql-server -y &>> $LOGFILE
    # Validate if the package is correctly installed
    VALIDATE $? "Installing MySQL Server"
fi
