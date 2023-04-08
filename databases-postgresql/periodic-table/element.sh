#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only --no-align -t -c"



CHECK_PARAMETER(){
  if [[ -z $1 ]]
  then
    echo "Please provide an element as an argument."
  else
    if [[ $1 =~ ^[0-9]+$ ]]
    then
      ATOMIC_NUMBER_REG=$($PSQL "SELECT * FROM elements WHERE atomic_number=$1")
    fi

    #if is word
    if [[ $1 =~ ^[a-zA-Z]*$ ]]
    then
      ATOMIC_NUMBER_REG=$($PSQL "SELECT * FROM elements WHERE symbol='$1'")

      if [[ -z $ATOMIC_NUMBER_REG ]]
      then
        ATOMIC_NUMBER_REG=$($PSQL "SELECT * FROM elements WHERE name='$1'")
      fi
    fi

    if [[ ! -z $ATOMIC_NUMBER_REG ]]
    then
      PROCESS_ELEMENT_REG $ATOMIC_NUMBER_REG
    else
      echo "I could not find that element in the database."
    fi
  fi
}

PROCESS_ELEMENT_REG(){
  IFS="|"
  read -a reg <<< "$1" 
  IFS=" "
  ATOMIC_NUMBER=$(FORMAT_SPACES ${reg[0]})
  SYMBOL=$(FORMAT_SPACES ${reg[1]})
  NAME=$(FORMAT_SPACES ${reg[2]})
      
  DISPLAY_INFO $ATOMIC_NUMBER $SYMBOL $NAME
}

DISPLAY_INFO(){
  #Get properties from 
  PROPERTIES=$($PSQL "SELECT atomic_mass,melting_point_celsius,boiling_point_celsius,type FROM properties INNER JOIN types USING(type_id) WHERE atomic_number=$1")
  IFS="|"
  read -a arr <<< "$PROPERTIES"
  IFS=" "
  ATOMIC_MASS=$(FORMAT_SPACES ${arr[0]})
  MELTING_POINT=$(FORMAT_SPACES ${arr[1]})
  BOILING_POINT=$(FORMAT_SPACES ${arr[2]})
  TYPE=$(FORMAT_SPACES ${arr[3]})

  echo "The element with atomic number $1 is $3 ($2). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $3 has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."

}

FORMAT_SPACES(){
  echo $1 | sed -E 's/^ *| *$//g'
}

CHECK_PARAMETER $1
