#!/usr/bin/bash
_help(){ cat <<E0F
Print latest title(s) and discussion link from hackernews, ordered by NUMBER.

Usage:
alias hn="/PATH to this/alias_hackernews.sh"
hn [OPTION]... [NUMBER]
  View the title and discussion link of NUMBER.
  Also put the discussion link into clipboard.

With no NUMBER, get the latest update from hackernews.

  -a, --all      Print all the NUMBER, title and discussion link.
  -q, --quiet    do not print anything to stdout
  -v, --verbose  increase verbosity
  -h, --help     display this help and exit
E0F
}

pblue='\e[38;5;67m'
bblue='\e[38;5;81m'
white='\e[38;5;255m'
orange='\e[38;5;136m'

main(){
    curl -s -x socks5h://127.0.0.1:9150 https://news.ycombinator.com/news -o /tmp/curl_out

    titles=$(rg -o 'storylink"\s?(?:|rel="nofollow")>([^<]*)' /tmp/curl_out -r '$1')
    IFS=$'\n'; for title in $titles; do
        id=$(rg --fixed-strings "$title" /tmp/curl_out | rg -o 'vote\?id=([0-9]*)' -r '$1')
        list="$list"$'\n'"$title $id"
    done

    index=$(wc -l /tmp/hnindex.txt 2>/dev/null | awk '{print $1}')

    IFS=$'\n'; for line in $list; do
        new=$(printf '%s' "$line" | anew /tmp/hnindex.txt)
        if [[ ! -z "$new" ]]; then
            (( index++ ))
            echo -e "${pblue}$index. ${white}[${bblue}${new% *}${white}](${orange}https://news.ycombinator.com/item?id=${new##* }${white})"
        fi
    done
}

pick(){
    new=$(awk -v num=$1 'FNR==num' /tmp/hnindex.txt)
    printf '%s' "https://news.ycombinator.com/item?id=${new##* }" | clipster -c
    echo -e "${white}[${bblue}${new% *}${white}](${orange}https://news.ycombinator.com/item?id=${new##* }${white})"
}

all(){
    IFS=$'\n'; for new in $(</tmp/hnindex.txt); do
        (( index++ ))
        echo -e "${pblue}$index. ${white}[${bblue}${new% *}${white}](${orange}https://news.ycombinator.com/item?id=${new##* }${white})"
    done
}

_main(){
    #see notdefault.sh for more complex options.
    if [[ $1 == '-h' || $1 == --help ]]; then
        _help
    elif [[ -z $1 || "${@:(-1)}" == '-' ]]; then
        main
    elif [[ $1 =~ ^[0-9]+$ ]]; then
        pick $1
    elif [[ $1 == '-a' || $1 == --all ]]; then
        all
    else
        echo "$@"
    fi
}

_source(){ :;}
[[ $0 == "$BASH_SOURCE" ]] && _main "$@" || _source
