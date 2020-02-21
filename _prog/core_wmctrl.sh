
_input_graphical_idle() {
	# DANGER: Wayland not yet supported. May cause rapid loop cycling.
	if [[ "$XDG_SESSION_TYPE" != "x11" ]] || [[ "$DISPLAY" == "" ]] || ps aux | grep wayland | grep -v grep > /dev/null 2>&1
	then
		echo 0
		return 1
	fi
	
	! type xprintidle >/dev/null 2>&1 && echo 0 && return 1
	
	xprintidle
	
	return 0
}


_input_graphical_idle_wait() {
	if [[ "$nochangewait" == 'true' ]]
	then
		sleep 0.1
		return 0
	fi
	
	local currentSleepInterval
	[[ "$1" != "" ]] && currentSleepInterval="$1" || currentSleepInterval=3000
	
	
	# DANGER: Expected not to be available under wayland.
	while [[ $(_input_graphical_idle) -lt "$currentSleepInterval" ]]
	do
		sleep 0.3
	done
	
	return 0
}

# ATTENTION: Configure.
_wmctrl_place_filter() {
	grep 'Dolphin$\|Konsole$\|KWrite$\|LibreOffice[a-zA-Z0-9\ ]*$\|Okular.*$\|Xournal$\|Xournal\ \-\ .*$\|Mozilla\ Firefox$\|Chromium$' | grep -v '^['a-zA-Z0-9']x['a-zA-Z0-9']*\ \-\|Plasma.*$\|Configure — Konsole.*$\|Confirm Close — Konsole.*$'
}

# ATTENTION: Configure.
_wmctrl_change_hash() {
	# DANGER: Will NOT respond to combination of windows closing and opening resulting in equal window count within time interval.
	# Usually acceptable, given low rate of typical critical user inputs.
	#wmctrl -l | _wmctrl_place_filter | wc -l | md5sum | tr -dc 'a-zA-Z0-9'
	
	wmctrl -l | _wmctrl_place_filter | sed 's/\(0x[a-zA-Z0-9]*\s*[0-9\-]*\s*[a-zA-Z0-9\/]*\s*\).*\(Dolphin$\|Konsole$\|KWrite$\|LibreOffice[a-zA-Z0-9\ ]*$\|Okular.*$\|Xournal$\|Xournal\ \-\ .*$\|Mozilla\ Firefox$\|Chromium$\)/\1\2/g' | md5sum | tr -dc 'a-zA-Z0-9'
}


_wmctrl_change_wait() {
	if [[ "$nochangewait" == 'true' ]]
	then
		sleep 0.1
		return 0
	fi
	
	local current_wmctrl_hash
	
	current_wmctrl_hash=$(_wmctrl_change_hash)
	while [[ $(_wmctrl_change_hash) == "$current_wmctrl_hash" ]]
	do
		sleep 0.3
	done
	
	return 0
}

_wmctrl_desk() {
	wmctrl -d | grep '^[0-9]*.*\*' | cut -f1 -d\  2>/dev/null | tr -dc '0-9'
}





_graphical_environment_change_wait() {
	if [[ "$nochangewait" == 'true' ]]
	then
		sleep 0.1
		return 0
	fi
	
	local current_wmctrl_hash
	local current_xrandr_hash
	
	current_wmctrl_hash=$(_wmctrl_change_hash)
	current_xrandr_hash=$(_xrandr_change_hash)
	while [[ $(_wmctrl_change_hash) == "$current_wmctrl_hash" ]] && [[ $(_xrandr_change_hash) == "$current_xrandr_hash" ]]
	do
		sleep 0.3
	done
	
	return 0
}






