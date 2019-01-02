#!/bin/bash

_yggradrasil_global_usage() {
echo 'Usage: yggdrasil <command> [args]

Yggdrasil permits to switch easily between two shell
contexts.
The available commands for execution are listed below.
You can use the --help flag in every other command than
help.

Common commands:
  create    Create a new context
  list      Print all existing context.
  edit      Open your current editor and edit the context.

All other commands:
  help      print usage
'
}

_yggradrasil_create_usage() {
echo 'Usage: yggdrasil create <context-name> [--help]

This command permits to create a new context. It will
open your current text editor to set variable name.
Notice that if the current context already exist, it
will be reset.

Note:
-> you can not name your context "None".
-> you can not set a variable name by CURRENT_CONTEXT.
'
}

_yggradrasil_edit_usage() {
echo 'Usage: yggdrasil edit <context-name> [--help]

This command permits to update a new context. It will
open your current text editor to update existing variable
or add new variable in the list.
If the context does not exist, this command will fail.

Note:
-> you can not name your context "None".
-> you can not set a variable name by CURRENT_CONTEXT.
'
}

_yggdrasil_edit_file() {
local base_dir="."
local context_dir="$base_dir/tmp"
"${EDITOR:-vi}" "$context_dir/$1"
}

_yggdrasil_create_file() {
local base_dir="."
local context_dir="$base_dir/tmp"
echo "# This file is a sample of context file.

# Please write the variable\'s name is upper case and the value
# in lower case.

# VARIABLE-NAME=VALUE
" > "$context_dir/$1"

}

_yggdrasil_create() {
local base_dir="."
local context_dir="$base_dir/tmp"
if [[ "$#" -eq 0 || "$1" == "--help" || "$2" == "--help" ]]; then
    _yggradrasil_create_usage
elif [[ "$1" == "None" ]]; then
    echo "Invalid context name. Please pick an other one."
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

_yggdrasil_edit() {
local base_dir="."
local context_dir="$base_dir/tmp"
if [[ "$#" -eq 0 || "$1" == "--help" || "$2" == "--help" ]]; then
    _yggradrasil_edit_usage
elif [[ "$1" == "None" ]]; then
    echo "Invalid context name. Please pick an other one."
elif [[ -f "$context_dir/$1" ]]; then
    _yggdrasil_edit_file $1
else
    echo 'This context does not exist. Please create it with the command "yggdrasil create"'
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
    "edit") _yggdrasil_edit $2 $3
            ;;
    *) _yggradrasil_global_usage;;
esac
}
