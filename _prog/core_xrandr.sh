

_xrandr_change_hash() {
	# WARNING: Use of wmctrl hash intended for embedded use case.
	xrandr --query | md5sum | tr -dc 'a-zA-Z0-9'
}

_xrandr_primary_string() {
	#https://unix.stackexchange.com/questions/409650/how-to-get-monitor-width-using-xrandr-query
	xrandr --query | grep 'primary\|default'
}

# ATTENTION: Override with 'ops' if necessary.
# DANGER: Unstable format.
# DANGER: Expected not to be available under wayland.
_xrandr_primary_string_extract_width() {
	awk -F '[ x+]' '/\<primary\>/{print $4}' | tr -dc '0-9\-'
}

# ATTENTION: Override with 'ops' if necessary.
# DANGER: Unstable format.
# DANGER: Expected not to be available under wayland.
_xrandr_primary_string_extract_height() {
	awk -F '[ x+]' '/\<primary\>/{print $5}' | tr -dc '0-9\-'
}





