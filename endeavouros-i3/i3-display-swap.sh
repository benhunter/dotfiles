#!/usr/bin/env bash
# https://gist.github.com/fbrinker/df9cfbc84511d807f45041737ff3ea02
# requires jq

if ! command -v jq &>/dev/null; then
    echo "jq could not be found"
    exit 1
fi

# Swaps workspaces between two displays, focus stays on the current active display

DISPLAY_CONFIG="$(i3-msg -t get_outputs | jq -r '.[]|select(.active == true) |"\(.current_workspace)"')"
ACTIVE_DISPLAY="$(i3-msg -t get_workspaces | jq -r '.[]|select(.focused == true) | "\(.output)"')"
IFS=$'\n'
for ROW in ${DISPLAY_CONFIG}; do
    i3-msg -- workspace --no-auto-back-and-forth "$ROW"
    i3-msg -- move workspace to output next
done
sleep 0.15
i3-msg -- focus output "${ACTIVE_DISPLAY}"

exit
#### original ####
# https://i3wm.org/docs/user-contributed/swapping-workspaces.html
DISPLAY_CONFIG=($(i3-msg -t get_outputs | jq -r '.[]|"\(.name):\(.current_workspace)"'))

for ROW in "${DISPLAY_CONFIG[@]}"
do
IFS=':'
read -ra CONFIG <<< "${ROW}"
if [ "${CONFIG[0]}" != "null" ] && [ "${CONFIG[1]}" != "null" ]; then
    echo "moving ${CONFIG[1]} right..."
    i3-msg -- workspace --no-auto-back-and-forth "${CONFIG[1]}"
    i3-msg -- move workspace to output right	
fi
done
