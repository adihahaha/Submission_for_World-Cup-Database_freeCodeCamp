#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")
echo $($PSQL "ALTER SEQUENCE teams_team_id_seq RESTART WITH 1")
echo $($PSQL "ALTER SEQUENCE games_game_id_seq RESTART WITH 1")

cat games.csv | while IFS=',' read YEAR ROUND WIN OPP WIN_G OPP_G
do
  if [[ $YEAR != "year" ]]
  then
    # get existing team_id
    GET_WIN_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WIN'")
    GET_OPP_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPP'")

    # if winning team does not exist
    if [[ -z $GET_WIN_TEAM_ID ]]
    then
      INSERT_WIN_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WIN')")
      # display verification
      if [[ $INSERT_WIN_TEAM == "INSERT 0 1" ]]
      then
        echo "Inserted $WIN into teams"
      fi
    fi

    # if opposing team does not exist
    if [[ -z $GET_OPP_TEAM_ID ]]
    then
      INSERT_OPP_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPP')")
      # display verification
      if [[ $INSERT_OPP_TEAM == "INSERT 0 1" ]]
      then
        echo "Inserted $OPP into teams"
      fi
    fi

  fi
done


cat games.csv | while IFS=',' read YEAR ROUND WIN OPP WIN_G OPP_G
do
  if [[ $YEAR != "year" ]]
  then
    # get existing team_id
    WIN_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WIN'")
    OPP_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPP'")

    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, winner_goals, opponent_id, opponent_goals) VALUES($YEAR, '$ROUND', $WIN_TEAM_ID, $WIN_G, $OPP_TEAM_ID, $OPP_G)")

    if [[ $INSERT_GAME == "INSERT 0 1" ]]
    then
      echo "Inserted game into games()"
    else
      echo "Insertion failed"
    fi
  fi
done
    