#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

FORMAT_SPACES(){
  echo $1 | sed -E 's/^ *| *$//g'
}

CHECK_USERNAME(){
  USERNAME_REG=$($PSQL "SELECT games_played,best_game FROM games WHERE username='$1'")

  if [[ -z $USERNAME_REG ]]
  then
    #if username not exists insert new user
    INSERT_USER=$($PSQL "INSERT INTO games (username) VALUES ('$1')")
    echo "Welcome, $1! It looks like this is your first time here."
  else
    #display data games if user exists
    IFS="|"
    read -a arr <<< "$USERNAME_REG"
    IFS=" "
    GAMES_PLAYED=$(FORMAT_SPACES ${arr[0]})
    BEST_GAME=$(FORMAT_SPACES ${arr[1]})

    echo "Welcome back, $1! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  fi
}

UPDATE_GAME(){
  USERNAME_REG=$($PSQL "SELECT games_played,best_game FROM games WHERE username='$1'")
  IFS="|"
  read PLAYED_GA BEST_GA <<< $USERNAME_REG
  IFS=" "
  #increment number of games
  PLAYED_GA=$(( PLAYED_GA + 1 ))
  
  #check for update best game
  if [[ $BEST_GA -ne 0 ]]
  then
    if [[ $BEST_GA -gt $2 ]]
    then
      BEST_GA=$2
    fi
  else 
    BEST_GA=$2
  fi

  UPDATE_GAME=$($PSQL "UPDATE games SET games_played=$PLAYED_GA,best_game=$BEST_GA WHERE username='$1'")
}

echo "Enter your username:"
read USERNAME

CHECK_USERNAME $USERNAME

echo "Guess the secret number between 1 and 1000:"
SECRET_NUMBER=$(( ( RANDOM % 1000 ) + 1 ))
echo $SECRET_NUMBER
read NUMBER
TRIES=1

while (( $NUMBER != $SECRET_NUMBER ))
do
  if [[ $NUMBER =~ ^[0-9]*$ ]]
  then
    if (( $NUMBER > $SECRET_NUMBER ))
    then
      echo "It's lower than that, guess again:"
    else
      echo "It's higher than that, guess again:"
    fi

    TRIES=$(( TRIES + 1 ))
  else
    echo "That is not an integer, guess again:"
  fi

  read NUMBER
done

UPDATE_GAME $USERNAME $TRIES

echo "You guessed it in $TRIES tries. The secret number was $SECRET_NUMBER. Nice job!"
