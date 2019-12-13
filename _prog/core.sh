##### Core

# "$1" == id
# "$2" == border
# "$3" == 'left/right'
_panel_place_sidebar_id() {
	[[ "$primaryGraphicalScreen_xrandr" == "" ]] && export primaryGraphicalScreen_xrandr=$(_xrandr_primary_string)
	[[ "$primaryGraphicalScreenWidth" == "" ]] && export primaryGraphicalScreenWidth=$(echo "$primaryGraphicalScreen_xrandr" | _xrandr_primary_string_extract_width)
	[[ "$primaryGraphicalScreenHeight" == "" ]] && export primaryGraphicalScreenHeight=$(echo "$primaryGraphicalScreen_xrandr" | _xrandr_primary_string_extract_height)
	
	local current_wmctrl_id
	current_wmctrl_id="$1"
	
	
	
	local currentBorder
	[[ "$3" == 'left' ]] && currentBorder=0
	[[ "$3" == 'right' ]] && currentBorder=$(bc <<< "$2 + 0")
	
	local currentWindowWidth
	[[ "$3" == 'left' ]] && currentWindowWidth="$2"
	[[ "$3" == 'right' ]] && currentWindowWidth=$(bc <<< "$primaryGraphicalScreenWidth - $2 - 0")
	
	
	
	wmctrl -ir "$current_wmctrl_id" -b add,maximized_vert
	wmctrl -ir "$current_wmctrl_id" -b add,maximized_horz
	wmctrl -ir "$current_wmctrl_id" -b remove,maximized_vert
	wmctrl -ir "$current_wmctrl_id" -b remove,maximized_horz
	wmctrl -ir "$current_wmctrl_id" -e 0,0,0,640,480
	wmctrl -ir "$current_wmctrl_id" -b add,maximized_vert
	[[ "$3" == 'left' ]] && wmctrl -ir "$current_wmctrl_id" -e 0,"$currentBorder",0,"$currentWindowWidth",600
	
	# ATTENTION: Configure for portrait layout if necessary.
	if [[ "$3" == 'right' ]]
	then
		wmctrl -ir "$current_wmctrl_id" -e 0,"$currentBorder",0,"$currentWindowWidth",600
		#wmctrl -ir "$current_wmctrl_id" -b add,maximized_horz
	fi
}

# ATTENTION: Override with 'ops' or update.
_panel_place_sidebar_id_rules_determine_fileDriven() {
	echo "$1" | grep ' '"$placement_quick"' ' > /dev/null 2>&1 && return 0
	echo "$1" | grep ' '"$placement_plates"' ' > /dev/null 2>&1 && return 0
	return 1
}

# ATTENTION: Override with 'ops' or update.
# Update with any other desired effective file manager expected to support wayland and provide a unique window title.
_panel_place_filter_filemanager() {
	# WARNING: Important - return value.
	grep 'Dolphin$'
}

_panel_place_sidebar_id_rules() {
	if echo "$1" | cut -f5- -d\  | grep "$ubiquitiousBashID"-noautorules > /dev/null 2>&1
	then
		return 0
	fi
	
	# DANGER: Expected to fail under wayland, allowing management of dialog windows.
	if xprop -id $(echo "$1" | cut -f2 -d\  | tr -dc '0-9\-') 2>/dev/null | grep _NET_WM_WINDOW_TYPE | grep -i 'dialog' > /dev/null 2>&1
	then
		return 0
	fi
	
	
	if _panel_place_sidebar_id_rules_determine_fileDriven "$1"
	then
		if echo "$1" | cut -f5- -d\  | _panel_place_filter_filemanager > /dev/null 2>&1
		then
			_panel_place_sidebar_id $(echo "$1" | cut -f1 -d\  ) 285 left
		else
			_panel_place_sidebar_id $(echo "$1" | cut -f1 -d\  ) 285 right
		fi
	fi
	
	return 0
}

_panel_place_update_procedure_filter() {
	if [[ "$panel_place_limit_desk" != "" ]]
	then
		grep ' '"$panel_place_limit_desk"' '
		return
	fi
	
	if [[ "$panel_place_limit_currentDesk" == 'true' ]]
	then
		grep ' '$(_wmctrl_desk)' '
		return
	fi
	
	cat
	return
}

# DANGER: For embedded performance reasons, this *procedure* may be allowed to be called directly.
# Do NOT use multithreaded without appropriate modifications!
# Comment with appropriate notice, any code using this fuction directly!
_panel_place_update_procedure() {
	umask 077
	
	# DANGER: Irregular single-thread only use of "bootTmp" for embedded performance.
	local current_wmctrl_listFile
	current_wmctrl_listFile="$bootTmp"/"$ubiquitiousBashIDshort"-update_wmctrl
	#current_wmctrl_listFile="$safeTmp"/"$ubiquitiousBashIDshort"-update_wmctrl
	
	
	#wmctrl -l -p | _wmctrl_place_filter | sed 's/\s\s*/ /g' | _panel_place_update_procedure_filter > "$current_wmctrl_listFile"

	# ATTENTION: Configure.
	# Reading in entire window list may incur significant performance risk on some platforms.
	# Alternatively, reading in a specified number of most recently created windows may allow some to eventually 'float' out of control.
	# New windows will always be assigned their default positions. The issue is risk of briefly confusing and disrupting work for inexperienced users.
	# ** Alternatively, it may be helpful to teminate old windows, for performance.
	#while read -r current_wmctrl_string
	wmctrl -l -p | _wmctrl_place_filter | sed 's/\s\s*/ /g' | _panel_place_update_procedure_filter | tail -n 14 | while read -r current_wmctrl_string
	do
		#if ! [[ $(echo "$current_wmctrl_string" | cut -f2 -d\  | tr -dc '0-9\-') -lt 0 ]]
		#then
			#true
			_panel_place_sidebar_id_rules "$current_wmctrl_string"
		#fi
	done #< "$current_wmctrl_listFile"
	
	umask 022
}

_panel_place_update_sequence() {
	_start
	
	if ! _panel_place_update_procedure "$@"
	then
		_stop 1
	fi
	
	_stop
}

_panel_place_update() {
	"$scriptAbsoluteLocation" _panel_place_update_sequence
}

_panel_place_update_currentDesk() {
	export panel_place_limit_currentDesk='true'
	"$scriptAbsoluteLocation" _panel_place_update_sequence
}





_panel_place_activate_app_currentDesk() {
	
	# DANGER: Irregular single-thread only use of "bootTmp" for embedded performance.
	local current_wmctrl_listFile
	#current_wmctrl_listFile="$bootTmp"/"$ubiquitiousBashIDshort"-update_wmctrl
	current_wmctrl_listFile="$safeTmp"/"$ubiquitiousBashIDshort"-update_wmctrl
	
	
	local current_wmctrl_pid
	local current_wmctrl_args
	
	local current_wmctrl_match
	current_wmctrl_match='false'
	local current_wmctrl_score
	current_wmctrl_score=0
	local current_wmctrl_score_count
	
	local current_arg1
	local current_arg2
	local current_arg3
	local current_arg4
	local current_arg5
	local current_arg6
	
	
	current_arg1="$1"
	#[[ -e "$1" ]] && current_arg1="$1"
	
	
	[[ -e "$2" ]] && current_arg2="$2"
	[[ -e "$3" ]] && current_arg3="$3"
	[[ -e "$4" ]] && current_arg4="$4"
	[[ -e "$5" ]] && current_arg5="$5"
	[[ -e "$6" ]] && current_arg6="$6"
	
	#echo "$current_arg1"
	#echo "$current_arg2"
	#echo "$current_arg3"
	#echo "$current_arg4"
	
	[[ "$current_arg1" == "" ]] && current_arg1="$ubiquitiousBashID"_doNotMatch
	[[ "$current_arg2" == "" ]] && current_arg2="$ubiquitiousBashID"_doNotMatch
	[[ "$current_arg3" == "" ]] && current_arg3="$ubiquitiousBashID"_doNotMatch
	[[ "$current_arg4" == "" ]] && current_arg4="$ubiquitiousBashID"_doNotMatch
	[[ "$current_arg5" == "" ]] && current_arg4="$ubiquitiousBashID"_doNotMatch
	[[ "$current_arg6" == "" ]] && current_arg4="$ubiquitiousBashID"_doNotMatch
	
	local current_arg1_absolute
	local current_arg2_absolute
	local current_arg3_absolute
	local current_arg4_absolute
	local current_arg5_absolute
	local current_arg6_absolute
	
	#current_arg1_absolute=$(_getAbsoluteLocation "$current_arg1")
	
	current_arg2_absolute=$(_getAbsoluteLocation "$current_arg2")
	current_arg3_absolute=$(_getAbsoluteLocation "$current_arg3")
	current_arg4_absolute=$(_getAbsoluteLocation "$current_arg4")
	current_arg5_absolute=$(_getAbsoluteLocation "$current_arg5")
	current_arg6_absolute=$(_getAbsoluteLocation "$current_arg6")
	
	#echo "$current_arg1_absolute"
	#echo "$current_arg2_absolute"
	#echo "$current_arg3_absolute"
	#echo "$current_arg4_absolute"
	
	
	
	
	
	# Duplicate. Ensures window appearing on first launch will be placed and activated.
	# Exception - filtered for current desktop only -  grep ' '$(_wmctrl_desk)' ' .
	# WARNING: Code may not be maintained if disabled. Reference other duplicate code.
	
	wmctrl -l -p | _wmctrl_place_filter | sed 's/\s\s*/ /g' | grep ' '$(_wmctrl_desk)' ' > "$current_wmctrl_listFile"
	while read -r current_wmctrl_string
	do
		current_wmctrl_pid=$(echo "$current_wmctrl_string" | cut -f3 -d\  )
		[[ "$current_wmctrl_pid" -le 0 ]] && continue
		
		current_wmctrl_args=$(ps -p "$current_wmctrl_pid" -o args= | head -n 1)
		
		if ( ! [[ -e "$current_arg2" ]] || [[ "$current_wmctrl_args" == *"$current_arg2"* ]] || [[ "$current_wmctrl_args" == *"$current_arg2_absolute"* ]] ) && ( ! [[ -e "$current_arg3" ]] || [[ "$current_wmctrl_args" == *"$current_arg3"* ]] || [[ "$current_wmctrl_args" == *"$current_arg3_absolute"* ]] ) && ( ! [[ -e "$current_arg4" ]] || [[ "$current_wmctrl_args" == *"$current_arg4"* ]] || [[ "$current_wmctrl_args" == *"$current_arg4_absolute"* ]] ) && ( ! [[ -e "$current_arg5" ]] || [[ "$current_wmctrl_args" == *"$current_arg5"* ]] || [[ "$current_wmctrl_args" == *"$current_arg5_absolute"* ]] ) && ( ! [[ -e "$current_arg6" ]] || [[ "$current_wmctrl_args" == *"$current_arg6"* ]] || [[ "$current_wmctrl_args" == *"$current_arg6_absolute"* ]] )
		then
			
			# ATTENTION: Update with any other required workarounds.
			[[ "$current_arg1" == *"dolphin"* ]] && [[ "$current_wmctrl_args" != "$current_arg1"* ]] && continue
			[[ "$current_arg1" == *"konsole"* ]] && [[ "$current_wmctrl_args" != "$current_arg1"* ]] && continue
			
			[[ -d "$current_arg2" ]] && [[ "$current_wmctrl_args" != "$current_arg1"* ]] && continue
			[[ "$current_arg2" == "$ubiquitiousBashID"_doNotMatch ]] && [[ "$current_wmctrl_args" != "$current_arg1"* ]] && continue
			
			_panel_place_sidebar_id_rules "$current_wmctrl_string"
			wmctrl -ia $(echo "$current_wmctrl_string" | cut -f1 -d\  )
			current_wmctrl_match='true'
			break
		fi
		
	done < "$current_wmctrl_listFile"
	
	#[[ "$current_wmctrl_score_count" -le 0 ]] && return 1
	[[ "$current_wmctrl_match" != 'true' ]] && return 1
	return 0
}

# ATTENTION: Configure.
# Some application windows do not need extensive workarounds, usually due to immediate instructions to show immediately.
_panel_place_app_simple() {
	[[ "$1" == 'kwrite' ]] && return 0
	
	return 1
}

# ATTENTION: Configure.
# Some application windows do not need extensive workarounds, usually due to immediate instructions to show immediately.
_panel_place_app_reasonable() {
	if _panel_place_app_simple "$1"
	then
		return 0
	fi
	
	[[ "$1" == 'dolphin' ]] && return 0
	
	[[ "$1" == 'konsole' ]] && return 0
	[[ "$1" == 'okular' ]] && return 0
	[[ "$1" == 'xournal' ]] && return 0
	
	#[[ "$1" == 'libreoffice' ]] && return 0
	
	return 1
}

# DANGER: For embedded performance reasons, this *procedure* may be allowed to be called directly.
# Do NOT use multithreaded without appropriate modifications!
# Comment with appropriate notice, any code using this fuction directly!
_panel_place_app_procedure() {
	
	export sharedHostProjectDir='/'
	export sharedGuestProjectDir='/'
	
	_virtUser "$@"
	
	if [[ "$2" == "" ]] || ! _panel_place_activate_app_currentDesk "${processedArgs[@]}"
	then
		true
		
		current_wmctrl_hash=$(_wmctrl_change_hash)
		
		#"$@" &
		"${processedArgs[@]}" &
		
		sleep 0.3
		
		if _panel_place_activate_app_currentDesk "${processedArgs[@]}"
		then
			_panel_place_app_simple "$1" && return 0
		fi
		
		#_panel_place_app_simple "$1" && [[ $(_wmctrl_change_hash) == "$current_wmctrl_hash" ]] && return 0
		
		# WARNING: Relies on specific wmcontrol behavior otherwise kept within _wmctrl_change_wait .
		local currentCycleCount
		currentCycleCount=0
		while [[ $(_wmctrl_change_hash) == "$current_wmctrl_hash" ]] && [[ "$currentCycleCount" != "7" ]]
		do
			sleep 0.3
			let currentCycleCount="$currentCycleCount"+1
		done
		sleep 0.3
		
		if _panel_place_activate_app_currentDesk "${processedArgs[@]}"
		then
			_panel_place_app_simple "$1" && return 0
		fi
		
		#_panel_place_app_simple "$1" && [[ $(_wmctrl_change_hash) == "$current_wmctrl_hash" ]] && return 0
		
		sleep 3
		if _panel_place_activate_app_currentDesk "${processedArgs[@]}"
		then
			_panel_place_app_reasonable "$1" && return 0
		fi
		
		sleep 5
		if _panel_place_activate_app_currentDesk "${processedArgs[@]}"
		then
			return 0
		fi
		
	else
		return 0
	fi
	
	return 1
}

_panel_place_app_sequence() {
	_start
	
	if ! _panel_place_app_procedure "$@"
	then
		_stop 1
	fi
	
	_stop 0
}


# Either switches to a window with same arguments, or launches specified application with arguments.
_panel_place_app() {
	"$scriptAbsoluteLocation" _panel_place_app_sequence "$@"
}








_panel_place_procedure() {
	#local current_wmctrl_desk=$(_wmctrl_desk)
	#[[ "$current_wmctrl_desk" != "$placement_quick" ]] && [[ "$current_wmctrl_desk" != "$placement_plates" ]] && return 0
	#export panel_place_limit_desk="$current_wmctrl_desk"
	#_panel_place_update_procedure "$@"
	
	export panel_place_limit_desk="$placement_quick"
	_panel_place_update_procedure "$@"
	
	export panel_place_limit_desk="$placement_plates"
	_panel_place_update_procedure "$@"
}

_panel_place_sequence() {
	_start
	
	_panel_place_procedure
	
	_stop
}

_panel_place() {
	"$scriptAbsoluteLocation" _panel_place_sequence "$@"
}


# ATTENTION: Override with 'ops' or similar.
_panel_place_loop() {
	_start
	
	while true
	do
		_panel_place_procedure "$@"
		_graphical_environment_change_wait
	done
	
	_stop
}




_panel_files() {
	local wmctrl_id_filemanager
	wmctrl_id_filemanager=$(wmctrl -l -p | _wmctrl_place_filter | sed 's/\s\s*/ /g' | grep ' '$(_wmctrl_desk)' ' | _panel_place_filter_filemanager | head -n 1 | cut -f1 -d\  )
	
	[[ "$wmctrl_id_filemanager" == "" ]] && return 0
	
	wmctrl -ia "$wmctrl_id_filemanager"
}





_refresh_anchors() {
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_true
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_false
	
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_panel_place
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_panel_place_loop
	
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_panel_place_app
	
	cp -a "$scriptAbsoluteFolder"/_anchor "$scriptAbsoluteFolder"/_panel_files
}









