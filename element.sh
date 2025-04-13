#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

NUM=$((RANDOM % 1001))

echo "Enter your username:"

read USERNAME

if [[ -z $USERNAME ]]
then
  echo "You have to enter your name"
else
  #search a user
  SEARCH_USER=$($PSQL "SELECT * FROM users WHERE username='$USERNAME'")
  
  #validate if user exists
  if [[ -z $SEARCH_USER ]]
  then
    #create user
    CREATE_USER=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")

    #USERID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

    #CREATE_GAME=$($PSQL "INSERT INTO games (user_id, games_played) VALUES ($USERID, 0) RETURNING game_id;")
    #GAME_ID=$(echo "$CREATE_GAME" | head -n1 | xargs)

    #CREATE_BEST_GAME=$($PSQL "INSERT INTO guesses (user_id,game_id,total_guesses) VALUES ($USERID,$GAME_ID,0)")

    echo "Welcome, $USERNAME! It looks like this is your first time here."
  else
    USERID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

    GAMES_PLAYED=$($PSQL "SELECT SUM(games_played) as total_games FROM games WHERE user_id=$USERID")

    echo "$GAMES_PLAYED"
    BEST_GAME=$($PSQL "SELECT MIN(total_guesses) as best_game FROM guesses WHERE user_id=$USERID")

    echo "Welcome back, $USERNAME You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."

    echo "Guess the secret number between 1 and 1000:"
    guess_number
  fi
fi

function guess_number(){
    read SECRET_NUMBER

    echo $SECRET_NUMBER
    echo $NUM

    if [[ $SECRET_NUMBER > $NUM ]]
    then  
      echo "It's lower than that, guess again:"
    else if [[ $SECRET_NUMBER < $NUM ]]
      echo "It's higher than that, guess again:"
    else
      echo ""
    fi

}
