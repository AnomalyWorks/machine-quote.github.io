#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon  --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU(){
  if [[ -z $1 ]]
  then
    echo "Welcome to My Salon, how can I help you?"
  else
    echo $1
  fi

  echo "$($PSQL "SELECT * FROM services")" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done
  
  read SERVICE_ID_SELECTED
  if [[ "$SERVICE_ID_SELECTED" =~ ^[0-9]+$ ]]
  then
    #if id selected exists
    SERVICE=$($PSQL "SELECT * FROM services WHERE service_id=$SERVICE_ID_SELECTED")
    if [[ -z $SERVICE ]]
    then
      MAIN_MENU "I could not find that service. What would you like today?"  
    else
      SERVICE_MENU $SERVICE_ID_SELECTED
    fi

  else
    MAIN_MENU "Only numbers are valid. Try again"
  fi
}

SERVICE_MENU(){
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

  #if customer no exists
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    #insert customer in db
    INSERT_CUSTOMER=$($PSQL "INSERT INTO customers (phone,name) VALUES ('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
  fi

  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$1")
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  CU_NAME_F=$(FORMAT_SPACES $CUSTOMER_NAME)
  SE_NAME_F=$(FORMAT_SPACES $SERVICE_NAME)

  echo -e "\nWhat time would you like your $SE_NAME_F, $CU_NAME_F?"
  read SERVICE_TIME
  
  SE_TIME_F=$(FORMAT_SPACES $SERVICE_TIME)
  #insert appointment in db
  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments (customer_id,service_id,time) VALUES ($CUSTOMER_ID,$1,'$SERVICE_TIME')")
  echo -e "\nI have put you down for a $SE_NAME_F at $SE_TIME_F, $CU_NAME_F."

}

FORMAT_SPACES(){
  echo $1 | sed -E 's/^ *| *$//g'
}

MAIN_MENU
