#!/bin/bash

PRG=$0
CMD=$1
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

FOLDERS_DB=~/.${PRG##*/}
test -f $FOLDERS_DB || touch $FOLDERS_DB

list() {
  cat $FOLDERS_DB
}

add() {
  ls -1d $@ | while read FOLDER
  do
    ADDED=`readlink -f $FOLDER`

    if [ `egrep "^$ADDED$" $FOLDERS_DB` ]
    then
      echo "already added: $ADDED" >&2
      continue
    fi

    echo +$ADDED
    echo $ADDED >> $FOLDERS_DB
  done
}
del() {
  ls -1d $@ | while read R
  do
    DELETED=`readlink -f $R`

    if [ -z `egrep "^$DELETED$" $FOLDERS_DB` ]
    then
      echo "repo not found: $DELETED" >&2
      continue
    fi

    mv $FOLDERS_DB $FOLDERS_DB.old

    cat $FOLDERS_DB.old | while read FOLDER
    do
      PATH=`readlink -f $FOLDER`
      if [ $PATH == $DELETED ]
      then
        echo -$DELETED
      else
        echo $DELETED >> $FOLDERS_DB
      fi
    done
  done
}

run() {
  cat $FOLDERS_DB | while read FOLDER
  do
    DIR=`pwd`
    cd $FOLDER

    echo $USER@`cat /etc/hostname`:`pwd`$ $ARGS

    bash -c "$ARGS" || true

    cd $DIR
    echo ""
  done
}

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

case "$CMD" in
  "list") ;& "all") list;;
  "add") add $@;;
  "del") ;& "delete") ;& "remove") ;& "rm") del $@;;
  "run") run $@;;
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

