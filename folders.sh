#!/bin/bash

PRG=$0

usage() {
  echo "Usage: $PRG <command> [arguments...]" >&2
  echo "">&2
  echo "  Commands:" >&2
  echo "    list - lists added folders" >&2
  echo "    add [folders...] - adds specified folders to the list" >&2
  echo "    del [folders...] - deletes specified folders from the list" >&2
  echo "    run <command-line> - runs specified command on all added folders" >&2
  echo "    usage - shows this message" >&2
  echo "" >&2
}

CMD=$1

# Arguments need to be properly escaped and quoted
# as they will be passed into another shell.
ARGS=""
for ARG in "${@:2}"
do
  ARG="${ARG//\\/\\\\}"
  if grep -q ' ' <<< "$ARG"
  then
    ARGS="$ARGS \"${ARG//\"/\\\"}\""
  else
    ARGS="$ARGS $ARG"
  fi
done

# Folders database file is derived from program name
# (symlinking the script creates another folder group)
FOLDERS_DB=~/.${PRG##*/}
test -f $FOLDERS_DB || touch $FOLDERS_DB

TTY=`tty`

# <COMMANDS>

list() {
  cat $FOLDERS_DB
}

add() {
  ls -1d $@ | while read FOLDER
  do
    ADDED=`readlink -f $FOLDER`

    if egrep -q "^$ADDED$" $FOLDERS_DB
    then
      echo "already added: $ADDED" >&2
      continue
    fi

    echo "+$ADDED"
    echo "$ADDED" >> $FOLDERS_DB
  done
}

del() {
  ls -1d $@ | while read ENTRY
  do
    DELETED=`readlink -f "$ENTRY"`

    if ! egrep -q "^$DELETED$" $FOLDERS_DB
    then
      echo "not found: $DELETED" >&2
      continue
    fi

    mv $FOLDERS_DB $FOLDERS_DB.old

    cat $FOLDERS_DB.old | while read FOLDER
    do
      ABSOLUTE_PATH=`readlink -f "$FOLDER"`
      if [[ "$ABSOLUTE_PATH" == "$DELETED" ]]
      then
        echo "-$DELETED"
      else
        echo "$ABSOLUTE_PATH" >> $FOLDERS_DB
      fi
    done
  done
}

run() {
  cat $FOLDERS_DB | while read FOLDER
  do
    DIR=`pwd`
    cd $FOLDER

    echo $USER@`cat /etc/hostname`:`pwd`$ $*

    bash -c "$*" 0<$TTY || true

    cd $DIR
    echo ""
  done
}

# </COMMANDS>

case "$CMD" in
  "list") ;& "all") list;;
  "add") add $ARGS;;
  "del") ;& "delete") ;& "remove") ;& "rm") del $ARGS;;
  "run") run $ARGS;;
  "help") ;&  "?") ;& "usage") usage;;
  "")
    echo "command is required" >&2
    echo "" >&2
    usage
    ;;
  *)
    echo "unknown command: $CMD" >&2
    echo "" >&2
    usage
    ;;
esac

