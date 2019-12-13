_input_graphical_idle_wait_benchmark_function() {
	# DANGER: Non-functional checks intended to simulate processing time ONLY.
	
	if [[ "$XDG_SESSION_TYPE" != "x11" ]] || [[ "$DISPLAY" == "" ]] || ps aux | grep wayland | grep -v grep > /dev/null 2>&1
	then
		false
	fi
	
	! type xprintidle >/dev/null 2>&1 && sleep 0.3 && false
	
	local currentSleepInterval
	[[ "$1" != "" ]] && currentSleepInterval="$1" || currentSleepInterval=3000
	
	[[ $(xprintidle > /dev/null 2>&1) -lt '0' ]]
}

_input_graphical_idle_wait_benchmark() {
	_stopwatch _input_graphical_idle_wait_benchmark_function
}

_xrandr_benchmark_function() {
	_xrandr_primary_string | _xrandr_primary_string_extract_width > /dev/null 2>&1
}

_xrandr_benchmark() {
	_stopwatch _xrandr_benchmark_function
}

_wmctrl_benchmark_function() {
	# WARNING: Also tests performace relevant to '_wmctrl_change_hash'.
	wmctrl -l -p -G | md5sum | tr -dc 'a-zA-Z0-9' > /dev/null 2>&1
}

_wmctrl_benchmark() {
	_stopwatch _wmctrl_benchmark_function
}


# Script to run within graphical window for tests.
_test_prog_sample_window_script() {
	echo '_test_prog_sample_window_script'
	echo $'\033]30;uk4uPhB663kVcygT0q wmctrl test window\007'
	echo '...'
	echo 'uk4uPhB663kVcygT0q wmctrl test interior'
	echo 'window title not set by above visible statement'
	echo '...'
	sleep 15
}


_test_prog() {
	local currentFailure='false'
	
	_getDep 'wmctrl'
	
	[[ $(_wmctrl_benchmark | tr -dc '0-9') -gt 75 ]] && echo 'fail: slow wmctrl' && currentFailure='true'
	
	# DANGER: Expected not to be available under wayland.
	_getDep 'xprintidle'
	_getDep 'xrandr'
	_getDep 'xprop'
	
	[[ $(xprintidle | tr -dc '0-9') == "" ]] && echo 'fail: xprintidle' && currentFailure='true'
	[[ $(xprintidle | tr -dc '0-9') -lt 0 ]] && echo 'fail: xprintidle' && currentFailure='true'
	[[ $(_input_graphical_idle_wait_benchmark | tr -dc '0-9') -gt 75 ]] && echo 'fail: slow xprintidle' && currentFailure='true'
	
	[[ $(_xrandr_primary_string | _xrandr_primary_string_extract_width) == "" ]] && echo 'fail: xrandr' && currentFailure='true'
	[[ $(_xrandr_primary_string | _xrandr_primary_string_extract_height) == "" ]] && echo 'fail: xrandr' && currentFailure='true'
	[[ $(_xrandr_primary_string | _xrandr_primary_string_extract_width) -lt 0 ]] && echo 'fail: xrandr' && currentFailure='true'
	[[ $(_xrandr_primary_string | _xrandr_primary_string_extract_height) -lt 0 ]] && echo 'fail: xrandr' && currentFailure='true'
	[[ $(_xrandr_benchmark | tr -dc '0-9') -gt 75 ]] && echo 'fail: slow xrandr' && currentFailure='true'
	[[ $(_xrandr_benchmark | tr -dc '0-9') -gt 75 ]] && echo 'fail: slow xrandr' && currentFailure='true'
	
	[[ $(_stopwatch xprop -id x 2>/dev/null | tr -dc '0-9') -gt 75 ]] && echo 'warn: slow xprop' && currentFailure='true'
	
	
	_getDep 'konsole'
	_getDep 'dolphin'
	
	konsole --separate -e "$scriptAbsoluteLocation" _test_prog_sample_window_script 2>/dev/null &
	timeout 15 dolphin > /dev/null 2>&1 &
	sleep 7
	
	
	# Collapsing spaces used to avoid unnecessary use of awk .
	# https://stackoverflow.com/questions/7142735/how-to-specify-more-spaces-for-the-delimiter-using-cut
	local current_wmctrl_testString_list
	current_wmctrl_testString_list=$(wmctrl -l -p -G | grep 'uk4uPhB663kVcygT0q wmctrl test window' | sed 's/\s\s*/ /g' 2>/dev/null)
	
	local current_wmctrl_testString_list_wId
	current_wmctrl_testString_list_wId=$(echo "$current_wmctrl_testString_list" | cut -f1 -d\  )
	
	local current_wmctrl_testString_list_deskNum
	current_wmctrl_testString_list_deskNum=$(echo "$current_wmctrl_testString_list" | cut -f2 -d\  )
	
	local current_wmctrl_testString_list_PID
	current_wmctrl_testString_list_PID=$(echo "$current_wmctrl_testString_list" | cut -f3 -d\  )
	
	local current_wmctrl_testString_list_gx
	current_wmctrl_testString_list_gx=$(echo "$current_wmctrl_testString_list" | cut -f4 -d\  )
	local current_wmctrl_testString_list_gy
	current_wmctrl_testString_list_gy=$(echo "$current_wmctrl_testString_list" | cut -f5 -d\  )
	local current_wmctrl_testString_list_gW
	current_wmctrl_testString_list_gW=$(echo "$current_wmctrl_testString_list" | cut -f6 -d\  )
	local current_wmctrl_testString_list_gH
	current_wmctrl_testString_list_gH=$(echo "$current_wmctrl_testString_list" | cut -f7 -d\  )
	
	# Unimportant, not tested.
	local current_wmctrl_testString_list_machineName
	current_wmctrl_testString_list_machineName=$(echo "$current_wmctrl_testString_list" | cut -f8 -d \  )
	
	local current_wmctrl_testString_list_TITLE
	current_wmctrl_testString_list_TITLE=$(echo "$current_wmctrl_testString_list" | cut -f9- -d \  )
	
	
	
	if [[ "$current_wmctrl_testString_list_wId" != "0x"* ]] || [[ $(echo "$current_wmctrl_testString_list_deskNum" | tr -dc '0-9') == "" ]] || [[ $(echo "$current_wmctrl_testString_list_PID" | tr -dc '0-9') == "" ]] || [[ $(echo "$current_wmctrl_testString_list_gx" | tr -dc '0-9') == "" ]] || [[ $(echo "$current_wmctrl_testString_list_gy" | tr -dc '0-9') == "" ]] || [[ $(echo "$current_wmctrl_testString_list_gW" | tr -dc '0-9') == "" ]] || [[ $(echo "$current_wmctrl_testString_list_gH" | tr -dc '0-9') == "" ]] || [[ "$current_wmctrl_testString_list_TITLE" == "" ]]
	#if true
	then
		currentFailure='true'
		echo 'wmctrl -l -p -G'
		echo 'wmctrl window list string - example, processed, constructed'
		echo 'wID deskNum PID gx gy gW gH host TITLE'
		echo "$current_wmctrl_testString_list"
		echo "$current_wmctrl_testString_list_wId" "$current_wmctrl_testString_list_deskNum" "$current_wmctrl_testString_list_PID" "$current_wmctrl_testString_list_gx" "$current_wmctrl_testString_list_gy" "$current_wmctrl_testString_list_gW" "$current_wmctrl_testString_list_gH" "$current_wmctrl_testString_list_machineName" "$current_wmctrl_testString_list_TITLE"
		
		echo 'fail: missing: wmctrl - constructed'
	fi
	
	# Unimportant, not tested.
	local current_wmctrl_testString_info_name
	current_wmctrl_testString_info_name=$(wmctrl -m | head -n 1 | tail -n 1 | cut -f2 -d\  )
	
	# Unimportant, not tested.
	local current_wmctrl_testString_info_class
	current_wmctrl_testString_info_class=$(wmctrl -m | head -n 2 | tail -n 1 | cut -f2 -d\  )
	
	# Unimportant, not tested.
	local current_wmctrl_testString_info_PID
	current_wmctrl_testString_info_PID=$(wmctrl -m | head -n 3 | tail -n 1 | cut -f2 -d\  )
	
	# Unimportant, not tested.
	local current_wmctrl_testString_info_deskMode
	current_wmctrl_testString_info_deskMode=$(wmctrl -m | head -n 4 | tail -n 1 | cut -f2 -d\  )
	
	
	# ATTENTION: Update with any other desired effective file manager expected to support wayland and provide a unique window title.
	if [[ $(wmctrl -l | sed 's/\s\s*/ /g' |  grep ' '$(_wmctrl_desk)' ' | grep 'Dolphin' | head -n 1 | cut -f1 -d\  | tr -dc 'a-zA-Z0-9') == "" ]]
	then
		currentFailure='true'
		
		echo 'fail: detect: file manager'
	fi
	
	
	
	
	[[ "$currentFailure" != 'false' ]] && _stop 1
	_stop 0
}

_setup_prog() {
	# Specifically desirable to use relatively lean Ubiquitous Bash.
	_setupUbiquitous_nonet
}


