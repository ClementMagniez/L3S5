!/usr/bin/env bash

OS=`lsb_release -ds 2>/dev/null || cat /etc/*release 2>/dev/null | head -n1 || uname -om`

OS=$(echo $OS | cut -d ' ' -f1)

if [ $OS = "Ubuntu" ] || [ $OS = "Debian"]; then
	sudo apt-get install ruby > /dev/null
	echo "Installation de Ruby"
	echo "Installation du gestionnaire de gemmes Ruby"
	sudo apt-get install rubygems > /dev/null
	echo "Installation des gemmes nécessaires (cette opération peut prendre un certain temps)"
	echo "Installation de ActiveRecord"
	sudo gem install activerecord > /dev/null
	echo "Installation de IniFile"
	sudo gem install inifile > /dev/null
	echo "Installation de GTK"
	sudo gem install gtk3 > /dev/null
fi

path=`pwd`

echo $path

#desk_path="/usr/share/applications/tents.desktop"
#if [ -e $desk_path ]; then
#	echo "Impossible de créer un raccourci bureau : un fichier sous ce nom existe déjà."
#else
#	sudo sh -c "echo '[Desktop Entry]
#Version=1.0 
#Type=Application
#Terminal=false
#Exec=${path}/bin/main.rb
#Name=Tents And Trees
#Comment=L3S5 info
#Icon=${path}/img/tents.png
#Categories=Game;' >> $desk_path"
#	echo "Fichier de lancement 'Tents And Trees' créé."
#fi


