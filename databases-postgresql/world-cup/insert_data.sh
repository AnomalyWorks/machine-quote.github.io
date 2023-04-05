#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "TRUNCATE TABLE games, teams")"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT W_GOALS O_GOALS
do
  if [[ $YEAR != year ]]
  then
    TEAM_ID_W=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    TEAM_ID_O=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    
    #winner check
    if [ -z $TEAM_ID_W ]
    then
      #insert team
      INSERT=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
      TEAM_ID_W=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi

    #opponent check
    if [ -z $TEAM_ID_O ]
    then
      #insert team
      INSERT=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
      TEAM_ID_O=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi
    
    #insert game
    INSERT=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES ($YEAR,'$ROUND',$TEAM_ID_W,$TEAM_ID_O,$W_GOALS,$O_GOALS)")

  fi
done