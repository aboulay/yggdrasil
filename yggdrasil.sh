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
'
}

_yggdrasil_create_file() {
echo "# This file is a sample of context file.

# Please write the variable\'s name is upper case and the value
# in lower case.

# VARIABLE-NAME=VALUE
" > $1
    "${EDITOR:-vi}" $1
}

_yggdrasil_create() {
if [[ "$#" -eq 0 || "$1" == "--help" || "$2" == "--help" ]]; then
    _yggradrasil_create_usage
elif [[ -f $1 ]]; then
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

yggdrasil() {
    case "$1" in
    "help") _yggradrasil_global_usage
            ;;
    "create") _yggdrasil_create $2 $3
            ;;
    *) _yggradrasil_global_usage;;
esac
}

yggdrasil $*