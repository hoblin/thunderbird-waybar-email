#!/bin/bash

# Thunderbird email count script for waybar

EMAIL_UNREAD_GLYPH="󰇮"
EMAIL_READ_GLYPH="󰇯"
THUNDERBIRD_PROFILE_DIR="$HOME/.thunderbird"

find_profile() {
    find "$THUNDERBIRD_PROFILE_DIR" -name "*.default*" -type d 2>/dev/null | head -1
}

get_unread_count() {
    local msf_file="$1"
    [ ! -f "$msf_file" ] && echo "0" && return

    local result=$(grep -o '(\^A2=[0-9A-Fa-f]*' "$msf_file" 2>/dev/null | tail -1)
    if [[ $result =~ \(\^A2=([0-9A-Fa-f]+) ]]; then
        echo $((16#${BASH_REMATCH[1]}))
    else
        echo "0"
    fi
}

find_inboxes() {
    local profile_dir="$1"
    local smart_inbox="$profile_dir/Mail/smart mailboxes/Inbox.msf"

    if [ -f "$smart_inbox" ]; then
        echo "$smart_inbox"
    else
        find "$profile_dir"/ImapMail/*/INBOX.msf "$profile_dir"/Mail/pop3.*/Inbox.msf 2>/dev/null
    fi
}

get_total_unread() {
    local profile_dir=$(find_profile)
    [ -z "$profile_dir" ] && echo "0" && return

    local total=0
    while read -r inbox_file; do
        [ ! -f "$inbox_file" ] && continue
        local count=$(get_unread_count "$inbox_file")
        total=$((total + count))
    done < <(find_inboxes "$profile_dir")
    echo "$total"
}

format_output() {
    local unread_count="$1"
    if [ "$unread_count" -gt 0 ]; then
        printf '{"text": "%s %s", "class": "unread"}\n' "$EMAIL_UNREAD_GLYPH" "$unread_count"
    else
        printf '{"text": "%s", "class": "read"}\n' "$EMAIL_READ_GLYPH"
    fi
}

main() {
    local unread_count=$(get_total_unread)
    format_output "$unread_count"
}

main "$@"
