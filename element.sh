#!/bin/bash
# Script for displaying element data from database based on their atomic number, symbol or name.

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c";

# function for printing output text
PRINT_RESULT() {
  echo $1 | while IFS=\| read TYPE_ID ATOMIC_NUMBER ATOMIC_MASS MELTING_POINT BOILING_POINT SYMBOL NAME TYPE
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done
}

if [[ $1 ]]
then
  # argument provided, search for atomic number or symbol or name
  SEARCH_PROPS=" SELECT * FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id)";

  # check if the input is a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    # search for the only number-like identifier
    ATOMIC_NUMBER_SEARCH_RESULT=$($PSQL "${SEARCH_PROPS} WHERE atomic_number=$1");

    if [[ ! -z $ATOMIC_NUMBER_SEARCH_RESULT ]]
    then
      PRINT_RESULT $ATOMIC_NUMBER_SEARCH_RESULT;
    else
      echo "I could not find that element in the database.";
    fi

  # if input not a number
  else
    # search for string-like identifiers
    SYMBOL_SEARCH_RESULT=$($PSQL "${SEARCH_PROPS} WHERE symbol='$1' ");
    NAME_SEARCH_RESULT=$($PSQL "${SEARCH_PROPS} WHERE name='$1' ");

    if [[ ! -z $SYMBOL_SEARCH_RESULT ]]
    then
      PRINT_RESULT $SYMBOL_SEARCH_RESULT;
    elif [[ ! -z $NAME_SEARCH_RESULT ]]
    then
      PRINT_RESULT $NAME_SEARCH_RESULT;
    else
      echo "I could not find that element in the database.";
    fi

  fi
else
  # no argument provided
  echo "Please provide an element as an argument.";
fi