#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

echo $($PSQL "TRUNCATE games, teams")

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS; do
  if [[ $YEAR != 'year' ]]
  then
    # look for winner
    WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    if [[ -z $WIN_ID ]]
    then
      RES=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi

    # look for the opponent
    OP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -z $OP_ID ]]
    then
      RES=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      OP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi

    RES=$($PSQL "INSERT INTO games(winner_id, opponent_id, winner_goals, opponent_goals, year, round) VALUES ($WIN_ID, $OP_ID, $WINNER_GOALS, $OPPONENT_GOALS, $YEAR, '$ROUND')")

  fi
done

# Do not change code above this line. Use the PSQL variable above to query your database.
