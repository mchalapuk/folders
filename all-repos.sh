#!/bin/bash

REPOS_DB=~/.all-repos
test -f $REPOS_DB || touch $REPOS_DB

PRG=$0
CMD=$1
shift

list() {
  cat $REPOS_DB
}

run() {
  echo -n ""
}

usage() {
  echo "Usage: $PRG <command> [arguments...]" >&2
  echo "">&2
  echo "  Commands:" >&2
  echo "    run <command-line> - runs specified command on all repositories" >&2
  echo "" >&2
}

case "$CMD" in
  "list") list;;
  "run") run $@;;
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

