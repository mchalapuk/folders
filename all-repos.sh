#!/bin/bash

REPOS_DB=~/.all-repos
test -f $REPOS_DB || touch $REPOS_DB

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

list() {
  cat $REPOS_DB
}

add() {
  ls -1d $@ | while read REPO
  do
    ADDED=`readlink -f $REPO`

    if [ `egrep "^$ADDED$" $REPOS_DB` ]
    then
      echo "already added: $ADDED" >&2
      continue
    fi

    echo +$ADDED
    echo $ADDED >> $REPOS_DB
  done
}
del() {
  ls -1d $@ | while read R
  do
    DELETED=`readlink -f $R`

    if [ -z `egrep "^$DELETED$" $REPOS_DB` ]
    then
      echo "repo not found: $DELETED" >&2
      continue
    fi

    mv $REPOS_DB $REPOS_DB.old

    cat $REPOS_DB.old | while read REPO
    do
      PATH=`readlink -f $REPO`
      if [ $PATH == $DELETED ]
      then
        echo -$DELETED
      else
        echo $DELETED >> $REPOS_DB
      fi
    done
  done
}

run() {
  cat $REPOS_DB | while read REPO
  do
    DIR=`pwd`
    cd $REPO

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
  echo "    list - lists added repositories" >&2
  echo "    add [folders...] - adds specified folders to repository list" >&2
  echo "    del [folders...] - deletes specified folders from repository list" >&2
  echo "    run <command-line> - runs specified command on all added repositories" >&2
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

