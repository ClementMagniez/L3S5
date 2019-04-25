#!/usr/bin/env bash

OS=`lsb_release -ds 2>/dev/null || cat /etc/*release 2>/dev/null | head -n1 || uname -om`

OS=$(echo $OS | cut -d ' ' -f1)

if [ $OS = "Ubuntu" ] || [ $OS = "Debian"]; then
	sudo apt-get install ruby-full > /dev/null
	echo "Installation de Ruby"
	echo "Installation de SQLite"
 sudo apt-get install libsqlite3-dev > /dev/null
	echo "Installation de GTK3"
 sudo apt-get install ruby-gtk3 > /dev/null
	echo "Installation du gestionnaire de gemmes Ruby"
	sudo apt-get install rubygems > /dev/null
	echo "Installation des gemmes nécessaires (cette opération peut prendre un certain temps)"
	echo "Installation de la gemme SQLite"
	sudo gem install sqlite3 > /dev/null
	echo "Installation de la gemme ActiveRecord"
	sudo gem install active_record > /dev/null
	echo "Installation de la gemme IniFile"
	sudo gem install inifile > /dev/null
	echo "Installation de la gemme GTK"
	sudo gem install gtk3 > /dev/null
fi


path=`pwd`

echo -e "!/usr/bin/env bash\nruby ${path}/lib/main.rb" > tents-trees
chmod +x tents-trees
echo -e "export PATH=$PATH:${path}" >> ~/.profile 
source ~/.profile

echo -e "[Desktop Entry]
Version=1.0 
Type=Application
Terminal=false
Icon=${path}/img/icon.png
Exec=${path}/tents-trees
Name=Tents And Trees
Comment=L3S5 info
Categories=Game;" > tents.desktop
echo "Fichier de lancement 'Tents And Trees' créé."
chmod +x tents.desktop
sudo cp tents.desktop /usr/share/applications/tents.desktop &> /dev/null

