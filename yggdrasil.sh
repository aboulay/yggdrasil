#!/bin/bash

_yggradrasil_global_usage() {
echo 'Usage: yggdrasil <command> [args]

Yggdrasil permits to switch easily between two shell
contexts.
The available commands for execution are listed below.
You can use the --help flag in every other command than
help.

Common commands:
  create    create a new context
  list      print all existing context.

All other commands
  help      print usage
'
}

_yggradrasil_create_usage() {
echo 'Usage: yggdrasil create <context-name> [--help]

Create permits to create a new context. It will
open your current text editor to set variable name.
Notice that if the current context already exist, it
will be reset.

Note: you can not name your context "None".
'
}

_yggdrasil_create_file() {
local context_dir="./tmp"
echo "# This file is a sample of context file.

# Please write the variable\'s name is upper case and the value
# in lower case.

# VARIABLE-NAME=VALUE
" > "$context_dir/$1"
    "${EDITOR:-vi}" "$context_dir/$1"
}

_yggdrasil_create() {
local context_dir="./tmp"
if [[ "$#" -eq 0 || "$1" == "--help" || "$2" == "--help" ]]; then
    _yggradrasil_create_usage
elif [[ "$1" == "None" ]]; then
    echo "Invalid name. Please pick an other one."
elif [[ -f "$context_dir/$1" ]]; then
    echo "Context file already exist. Do you want to reset the context? [Y/N]"
    read answer
    if [[ $answer == 'Y' ]]; then
        _yggdrasil_create_file $1
    elif [[ $answer == 'N' ]]; then
        echo "Nothing will be done."
    else
        echo "Invalid answer. Please try again."
    fi
else
    _yggdrasil_create_file $1
fi    
}

_yggdrasil_list() {
local base_dir="."
source $base_dir/yggdrasil.conf
local context_dir="$base_dir/tmp"

echo "This is a list of all contexts:"
if [[ $CURRENT_CONTEXT == "None" ]]; then
    echo "* None (default)"
else
    echo "  None (default)"
fi
for context in "$context_dir"/*
do
  local context_name="$(basename $context)"
  if [[ $CURRENT_CONTEXT == "$context_name" ]]; then
      echo "* $context_name"
  else
      echo "  $context_name"
  fi
done
}

yggdrasil() {
    case "$1" in
    "help") _yggradrasil_global_usage
            ;;
    "create") _yggdrasil_create $2 $3
            ;;
    "list") _yggdrasil_list $2 $3
            ;;
    *) _yggradrasil_global_usage;;
esac
}

# TODO: To remove at the end of the project development
yggdrasil $*