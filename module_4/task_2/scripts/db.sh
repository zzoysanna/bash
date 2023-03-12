#!/bin/bash

FILE=../data/users.db
inverseParam="$2"

help() {
  echo '-------------------------------------------'
  echo
  echo '################ Help info ################'
  echo
  echo 'You can use options below:'
  echo 'help - show help page'
  echo 'add - add user to the list'
  echo 'find - find user in the list'
  echo 'list - show the list of users. --inverse parameter may be applied to show the list in reverse order'
  echo 'backup - create backup file'
  echo 'restore - restore from backup'
  echo
  echo '-------------------------------------------'
}

add() {
  while ! [[ $username =~ ^[a-zA-Z]+$ ]]; do
    echo 'Type user name:'
    read username
  done

  while ! [[ $role =~ ^[a-zA-Z]+$ ]]; do
    echo 'Type user role:'
    read role
  done

  checkDbFile
  echo "$username, $role" >> $FILE
  echo "User data added"
}

checkDbFile() {
  if ! [ -f "$FILE" ]; then
    echo "File $FILE doesn't exist. Would you like to create it?"
    echo "1 - yes"
    read answer;
    case $answer in
      1)
        touch $FILE;;
      *)
        echo "Can't continue without a db"
        exit;;
    esac
  fi
}

find() {
  echo 'Type username to find:'
  read usernameToFind
  checkDbFile
  result=$(cat $FILE | grep -i "^$usernameToFind\>")
  echo 'Search result:'
  if [[ $result == '' ]]; then
    echo 'User not found'
  else
    echo $result
  fi
}

list() {
  checkDbFile;
  if [[ $inverseParam == "--inverse" ]]; then
    cat $FILE | nl | sort -r
  else
    cat $FILE | nl
  fi
}

backup() {
  checkDbFile;
  backupFileName="../data/$(date +%d-%m-%Y)-users.db.backup";
  cp $FILE $backupFileName
  echo 'Backup is ready!'
}

restore() {
  cd ../data;
  fileList=$(ls | grep '.backup\>')
  backupFileName=$(ls | grep '.backup\>' | sort -t- -k3,3 -k2,2 -k1,1 | tail -n 1)
  if [ -f "$backupFileName" ]; then
    echo $backupFileName
    cp $backupFileName $FILE
    echo 'Data is restored'
  else
    echo 'Backup file not found'
  fi
}

case $1 in
  add)
    add;;
  find)
    find;;
  list)
    list;;
  backup)
    backup;;
  restore)
    restore;;
  '' | help | *)
    help;;
esac
