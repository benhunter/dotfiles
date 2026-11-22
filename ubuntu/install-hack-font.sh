mkdir -p ~/.local/share/fonts
curl -fLo ~/Downloads/Hack.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.5.1/Hack.zip 
unzip ~/Downloads/Hack.zip -d ~/.local/share/fonts/Hack
fc-cache -fv
fc-list | grep Hack
