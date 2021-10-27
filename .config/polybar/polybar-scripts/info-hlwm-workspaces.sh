#!/usr/bin/env bash

# Multi monitor support. Needs MONITOR environment variable to be set for each instance of polybar
# If MONITOR environment variable is not set this will default to monitor 0
# Check https://github.com/polybar/polybar/issues/763

#set -x

#echo "" > ~/.config/polybar/log.txt

MON_IDX="0"
mapfile -t MONITOR_LIST < <(polybar --list-monitors | cut -d":" -f1 | tac)
for (( i=0; i<$((${#MONITOR_LIST[@]})); i++ )); do
  [[ ${MONITOR_LIST[${i}]} == "$MONITOR" ]] && MON_IDX="$i"
  #echo "MONITOR_LIST[$i] = ${MONITOR_LIST[${i}]}" >> ~/.config/polybar/log.txt
  #echo "MONITOR=$MONITOR" >> ~/.config/polybar/log.txt
  #echo "MON_IDX=$MON_IDX" >> ~/.config/polybar/log.txt
done;

#echo "" >> ~/.config/polybar/log.txt
#echo "$MON_IDX---"

herbstclient --idle "tag_*" 2>/dev/null | {

    while true; do
        # Read tags into $tags as array
        IFS=$'\t' read -ra tags <<< "$(herbstclient tag_status "${MON_IDX}")"
        {
            for i in "${tags[@]}" ; do
                # Read the prefix from each tag and render them according to that prefix
                case ${i:0:1} in
                    '.')
                        # the tag is empty
                        # gray
                        ;;
                    ':')
                        # the tag is not empty
                        # White
                        echo "%{F#fff}"
                        ;;
                    '+')
                        # the tag is viewed on the specified MONITOR, but this monitor is not focused.
			echo "%{F#FF9900}"
                        ;;
                    '#')
                        # the tag is viewed on the specified MONITOR and it is focused.
                        echo "%{u#FF9900}%{+u}%{F#FF9900}"
                        ;;
                    '-')
                        # the tag is viewed on a different MONITOR, but this monitor is not focused.
			echo "%{F#0011FF}"
                        ;;
                    '%')
                        # the tag is viewed on a different MONITOR and it is focused.
			echo "%{u#0011ff}%{+u}%{F#0011FF}"
                        ;;
                    '!')
                        # the tag contains an urgent window.
                        echo "%{F#ff0000}"
                        ;;
                esac

                # focus the monitor of the current bar before switching tags
                echo "%{A1:herbstclient focus_monitor ${MON_IDX}; herbstclient use ${i:1}:}  ${i:1}  %{A -u -o F- B-}"
            done

            # reset foreground and background color to default
            echo "%{F-}%{B-}%{-u}"
        } | tr -d "\n"

    echo

    # wait for next event from herbstclient --idle
    read -r || break
done
} 2>/dev/null

#set +x
