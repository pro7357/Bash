#!/usr/bin/bash
_help(){ cat <<E0F
Usage: default [OPTION]... [FILE]...
Do default thing to FILE(s). Output to standard output.

With no FILE, or when FILE is -, read standard input.

  -q, --quiet    do not print anything to stdout
  -v, --verbose  increase verbosity
  -h, --help     display this help and exit
E0F
}

_menu(){
    #see notdefault.sh for more complex options.
    if [[ $1 == '-h' || $1 == --help ]]; then
        _help
    elif [[ "${@:(-1)}" == '-' ]]; then
        echo "_pipe"
    elif [[ -z $1 ]]; then
        echo "_auto"
    else
        echo "$@"
    fi
}
_source(){ :;}
[[ $0 == "$BASH_SOURCE" ]] && _menu "$@" || _source
