#!/bin/bash

# Getting User ID using id command
# User ID of super user is 0
USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTNAME=$(echo $0 | cut -d '.' -f 1)
LOGFILE="/tmp/$SCRIPTNAME-$TIMESTAMP.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
W="\e[0m"

# Function to check if package is installed correctly, else quit
# Because this can be re-used for other packages, it is made to a function
VALIDATE(){
    if [ $? -ne 0 ]
    then
        echo "$2...$R FAILED $W"
    else
        echo "$2...$G SUCCESS $W"
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
    echo "MySQL Server package is already installed...$Y SKIPPED $W"
else
    dnf install mysql-server -y &>> $LOGFILE
    # Validate if the package is correctly installed
    VALIDATE $? "Installing MySQL Server"
fi

systemctl enable mysqld
VALIDATE $? "Enabling mysqld service"

systemctl start mysqld
VALIDATE $? "Starting mysqld service"

# mysql_secure_installation --set-root-pass ExpenseApp@1