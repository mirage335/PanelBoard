
_panelApp-SingleClick_write-single() {
	sed -i 's/SingleClick=false/SingleClick=true/g' "$1"
}
_panelApp-SingleClick_write() {
	_panelApp-SingleClick_write-single "$globalFakeHome"/.config/kdedefaults/kdeglobals
	_panelApp-SingleClick_write-single "$globalFakeHome"/.config/kdeglobals
	_panelApp-SingleClick_write-single "$globalFakeHome"/.kde/share/config/kdeglobals
}

_panelApp-copyHome() {
	if [[ ! -e "$globalFakeHome"/.config/dolphinrc ]]
	then
		_editFakeHome true
		mkdir -p "$globalFakeHome"/.config/
		cp -a "$HOME"/.config/. "$globalFakeHome"/.config/
		mkdir -p "$globalFakeHome"/.local/
		cp -a "$HOME"/.local/. "$globalFakeHome"/.local/
		mkdir -p "$globalFakeHome"/.kde
		cp -a "$HOME"/.kde/. "$globalFakeHome"/.kde/
		
		mkdir -p "$globalFakeHome"/.config
		cp -a "$HOME"/.config/dolphinrc "$globalFakeHome"/.config/
		
		#_instance_internal "$globalFakeHome"/. "$actualFakeHome"/ > /dev/null 2>&1
		
		mkdir -p "$globalFakeHome"/.local/share/applications
		cp -a "$scriptLib"/fileAssociations/*.desktop "$globalFakeHome"/.local/share/applications
		xdg-desktop-menu forceupdate
		xdg-desktop-menu forceupdate --mode user
		xdg-desktop-menu forceupdate --mode system
	fi
}

#"$HOME"/core/infrastructure/PanelBoard/_panel_place_app "$HOME"/core/infrastructure/PanelBoard/ubiquitous_bash.sh dolphin "$@"
_dolphin_editFakeHome() {
	_panelApp-copyHome
	
	_panelApp-SingleClick_write
	
	#unset QT_QPA_PLATFORMTHEME
	
	#export keepFakeHome="false"
	#export setFakeHome=true
	_editFakeHome dolphin --new-window "$@"
}





