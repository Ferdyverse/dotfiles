#!/bin/sh

cache_path="${XDG_CACHE_HOME:-$HOME/.cache}/waybar-updates"

case "$1" in
show)
    if [ -f "$cache_path" ]; then
        cat "$cache_path"
    else
        printf '{"text": "-"}\n'
    fi
    ;;
refresh)
    pac="$(checkupdates)"
    aur="$(aur repo -u)"
    vcs="$(aur vercmp-devel)"
    off="$(checkofficial)"
    dif="$(pacdiff -o)"
    reb="$(checkrebuild)"
    rep="$(repoctl status | grep -v 'On repo' | grep -v '^$' | grep -v 'Everything up-to-date' | sed 's/^\s*//g')"

    pac_n=$(printf "$pac" | grep -c '^')
    aur_n=$(printf "$aur" | grep -c '^')
    vcs_n=$(printf "$vcs" | grep -c '^')
    off_n=$(printf "$off" | grep -c '^')
    dif_n=$(printf "$dif" | grep -c '^')
    reb_n=$(printf "$reb" | grep -c '^')
    rep_n=$(printf "$rep" | grep -c '^')

    text=""
    tooltip=""

    [ -n "$text" -o -n "$rep" ] && text="/${rep_n}${text}"
    [ -n "$rep" ] && tooltip="AUR repo needs cleaning:\n\n$rep\n\n${tooltip}"
    [ -n "$text" -o -n "$off" ] && text="/${off_n}${text}"
    [ -n "$off" ] && tooltip="Became official:\n\n$off\n\n${tooltip}"
    [ -n "$text" -o -n "$reb" ] && text="/${reb_n}${text}"
    [ -n "$reb" ] && tooltip="Rebuild required:\n\n$reb\n\n${tooltip}"
    [ -n "$text" -o -n "$dif" ] && text="/${dif_n}${text}"
    [ -n "$dif" ] && tooltip="pacdiff:\n\n$dif\n\n${tooltip}"
    [ -n "$text" -o -n "$vcs" ] && text="/${vcs_n}${text}"
    [ -n "$vcs" ] && tooltip="VCS:\n\n$vcs\n\n${tooltip}"
    [ -n "$text" -o -n "$aur" ] && text="/${aur_n}${text}"
    [ -n "$aur" ] && tooltip="AUR:\n\n$aur\n\n${tooltip}"
    [ -n "$text" -o -n "$pac" ] && text="${pac_n}${text}"
    [ -n "$pac" ] && tooltip="pacman:\n\n$pac\n\n${tooltip}"

    tooltip="$(printf "$tooltip" | perl -pe 's/\n/\\n/g' | perl -pe 's/(?:\\n)+$//')"

    if [ -z "$text" ]; then
        printf '{"text": "0"}\n' >"$cache_path"
    else
        printf '{"text": "%s", "tooltip": "%s", "alt": "icon" }\n' "$text" "$tooltip" >"$cache_path"
    fi

    pkill -RTMIN+1 -x waybar
    ;;
*)
    echo >&2 "Usage: $0 <show|refresh>"
    exit 1
    ;;
esac
