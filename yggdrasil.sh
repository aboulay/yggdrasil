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
  remove    Remove a specific existing context.
  use       Change the current context to a new one.

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

_yggdrasil_remove_usage() {
echo 'Usage: yggdrasil remove <context-name> [--help]

This command permits to remove an existing context. If the
wanted context is the current context, the new context will
be "None". If the context does not exist, it will fail.

Note:
-> "None" is an invalid context name.
'
}

_yggdrasil_use_usage() {
echo 'Usage: yggdrasil use <context-name> [--help]

This command permits to change the current context by
the selected one. It will fail if the context does not
exist.
'
}

_yggdrasil_edit_file() {
local context_dir="$YGGDRASIL_FOLDER/context"
"${EDITOR:-vi}" "$context_dir/$1"
}

_yggdrasil_unset_context() {
    local context_dir="$YGGDRASIL_FOLDER/context"

    OLD_CONTEXT_NAME=$1
    if [[ $OLD_CONTEXT_NAME != "None" ]]; then
        for line in $(cat $context_dir/$OLD_CONTEXT_NAME | awk '{print $1;}' | cut -d "=" -f1)
        do
            if [[ $line != "#" && $line != "\n" ]]; then
                unset $line
            fi
        done
    fi
}

_yggdrasil_set_context() {
    local context_dir="$YGGDRASIL_FOLDER/context"

    NEW_CONTEXT_NAME=$1
    
    if [[ $NEW_CONTEXT_NAME != "None" ]]; then
        source $context_dir/$NEW_CONTEXT_NAME
    fi

    sed -i "1s/.*/CURRENT_CONTEXT=$1/" $YGGDRASIL_FOLDER/yggdrasil.conf
    source $YGGDRASIL_FOLDER/yggdrasil.conf
}

_yggdrasil_switch_context() {
    _yggdrasil_unset_context $CURRENT_CONTEXT
    _yggdrasil_set_context $1
}

_yggdrasil_create_file() {
local context_dir="$YGGDRASIL_FOLDER/context"
echo "# This file is a sample of context file.

# Please write the variable\'s name is upper case and the value
# in lower case.

# VARIABLE-NAME=\"VALUE\"
" > "$context_dir/$1"

}

_yggdrasil_create() {
local context_dir="$YGGDRASIL_FOLDER/context"
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
local context_dir="$YGGDRASIL_FOLDER/context"
source $YGGDRASIL_FOLDER/yggdrasil.conf
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

_yggdrasil_remove() {
source $YGGDRASIL_FOLDER/yggdrasil.conf
local context_dir="$YGGDRASIL_FOLDER/context"
if [[ "$#" -eq 0 || "$1" == "--help" || "$2" == "--help" ]]; then
    _yggdrasil_remove_usage
elif [[ "$1" == "None" ]]; then
    echo "Invalid context name. Please pick an other one."
elif [[ -f "$context_dir/$1" ]]; then
    if [[ $CURRENT_CONTEXT == $1 ]]; then
        _yggdrasil_switch_context "None"
    fi
    rm "$context_dir/$1"
else
    echo 'This context does not exist. It cannot be destroyed.'
fi
}

_yggdrasil_use() {
source $YGGDRASIL_FOLDER/yggdrasil.conf
local context_dir="$YGGDRASIL_FOLDER/context"
if [[ "$#" -eq 0 || "$1" == "--help" || "$2" == "--help" ]]; then
    _yggdrasil_use_usage
elif [[ -f "$context_dir/$1" || $1 == "None" ]]; then
    _yggdrasil_switch_context $1
else
    echo 'This context does not exist. Please create it with the command "yggdrasil create"'
fi
}

_yggdrasil_list() {
source $YGGDRASIL_FOLDER/yggdrasil.conf
local context_dir="$YGGDRASIL_FOLDER/context"

echo "This is a list of all contexts:"
if [[ $CURRENT_CONTEXT == "None" ]]; then
    echo "* None (default)"
else
    echo "  None (default)"
fi
if [ -z "$(ls -A $context_dir)" ]; then
   return
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
    "remove") _yggdrasil_remove $2 $3
            ;;
    "use") _yggdrasil_use $2 $3
           ;;
    *) _yggradrasil_global_usage;;
esac
}

yggdrasil_init() {
    YGGDRASIL_FOLDER="$HOME/.yggdrasil"
    source $YGGDRASIL_FOLDER/yggdrasil.conf
}

yggdrasil_ps1() {
local color_neutral='\033[0m'
local color_header='\033[0;31m'
local color_context='\033[0;36m'
printf "(${color_header}\u264E${color_neutral}  ${color_context}$CURRENT_CONTEXT${color_neutral})"
}

yggdrasil_init