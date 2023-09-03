
#"$HOME"/core/infrastructure/PanelBoard/_panel_place_app "$HOME"/core/infrastructure/PanelBoard/ubiquitous_bash.sh dolphin "$@"
_panelApp-dolphin_editHome() {
	if [[ ! -e "$globalFakeHome"/.config/dolphinrc ]]
	then
		_editFakeHome true
		mkdir -p "$globalFakeHome"/.config/
		cp -a "$HOME"/.config/. "$globalFakeHome"/.config/
		mkdir -p "$globalFakeHome"/.local/
		cp -a "$HOME"/.local/. "$globalFakeHome"/.local/
		mkdir -p "$globalFakeHome"/.kde
		cp -a "$HOME"/.kde/. "$globalFakeHome"/.kde/
		
		#mkdir -p "$globalFakeHome"/.config
		#cp -a "$HOME"/.config/dolphinrc "$globalFakeHome"/.config/
		
		#_instance_internal "$globalFakeHome"/. "$actualFakeHome"/ > /dev/null 2>&1
		
		
		sed -i 's/SingleClick=false/SingleClick=true/g' "$globalFakeHome"/.config/kdeglobals
		sed -i 's/SingleClick=false/SingleClick=true/g' "$globalFakeHome"/.kde/share/config/kdeglobals
	fi
	
	sed -i 's/SingleClick=false/SingleClick=true/g' "$globalFakeHome"/.config/kdeglobals
	sed -i 's/SingleClick=false/SingleClick=true/g' "$globalFakeHome"/.kde/share/config/kdeglobals
	
	#export keepFakeHome="false"
	#export setFakeHome=true
	_editFakeHome dolphin --new-window "$@"
}





