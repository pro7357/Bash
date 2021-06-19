#!/usr/bin/bash
_help(){ cat <<E0F
Usage: default [OPTION]... [FILE]...
Do default thing to FILE(s). Output to standard output.

With no FILE, or when FILE is -, read standard input.

  -q, --quiet    do not print anything to stdout
  -v, --verbose  increase verbosity
  -V, --version  output version information and exit
  -h, --help     display this help and exit
E0F
}

_main(){
    #main
    local directory
    local pattern
    local color=true

    while :; do
        case "$1" in
        -d | --directory)
            directory=$2
            shift 2
            ;;
        --directory=*)
	        directory=${1#*=}
            shift
            ;;
        --fail-fast)
            fail_fast=true
            shift
            ;;
        --pattern)
            pattern=$2
            shift 2
            ;;
        --pattern=*)
            pattern=${1#*=}
            shift
            ;;
        --no-color)
            color=false
            shift
            ;;
        -h | --help)
            _help
            ;;
        -V)
            _version | head -n1
            printf "\nUse --version for more information, release, license and etc.\n"
            ;;
        --version)
            _version
            ;;
        -|'')
            _stdin
            ;;
        --)
            break
            ;;
        -*)
            printf "%s: unrecognized option -- '%s'\n" "$0" "$1" 1>&2
            exit 1
            ;;
        *)
            break
        esac
    done
}

_stdin(){
    file="${1:-$(cat --)}"

    while IFS= read -r line; do
        #printf '%s\n' "hey $line" # Or: env POSIXLY_CORRECT=1 echo "$line"
        echo "$line"
    done <<< "$file"
}

_version(){ cat <<E0F
default v0.0.1 are under development and known to be "incomplet and inkorrect".

less is more
E0F
}

_source(){ :;}
[[ $0 == "$BASH_SOURCE" ]] && _main "$@" || _source
#https://github.com/helpermethod/bash-specs/blob/master/src/bash-specs
