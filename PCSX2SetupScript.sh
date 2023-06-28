#!/bin/bash

#config menu here

# Main function here.

function main () {
	clear
	printf " %-4s \nInstall one of the following versions of PCSX2:\n
	1 - Install apt version.\n
	2 - Install Flatpak version.\n
	3 - Install Flatpak along with PCSX2.\n
	4 - Configurations Menu\n
	5 - Run PCSX2\n
	6 - Exit\n\n"
	read -p "Which version of PCSX2 would you like to install? " choice01
	
	case $choice01 in
		1 ) echo 'Ok, installing apt version of PCSX2.';
			install_pcsx2viaapt
			break;;
		2 ) echo 'Ok, installing the Flatpak version of PCSX2.';
			install_pcsx2viaflatpak
			break;;
		3 ) echo 'Ok, Installing Flatpak with PCSX2.';
			install_flatpak;
			break;;
		4 ) echo 'Ok, choosing the config menu. ';
			configmenu;;
		5 ) echo 'Ok, running PCSX2.';
			printf "%-4s \n1 - flatpak\n2 - apt\n3 - return home\n";
			read -p "Flatpak or apt? " yn6;
			case $yn6 in
				1 ) clear;
					launchpcsx2flatpak
					break;;
				2 ) clear;
					launchpcsx2apt
					break;;
				3 ) clear;
					main
					break;;
			esac
			break;;
		6 ) echo 'Exit';
			clear;
			read -p 'Are you sure you want to exit? [Y/N] ' yn
				case $yn in
					[Yy] ) echo 'Exiting...';
						clear;
						exit;;
					[Nn] ) echo 'Returning...';
						clear;
						main
						break;;
				esac
			break;;
		* ) echo 'invalid response';
		    clear;
		    main
		    break;;
	esac
}


function configmenu () {
	clear
	printf " %-4s \nInstall one of the following versions of PCSX2:\n
	1 - Add BIOS files\n
	2 - Add ROMS\n
	3 - Configure Network\n
	4 - Graphics\n
	5 - Run PCSX2\n
	6 - Manage Directory\n
	7 - View Roms\n
	8 - Main Menu\n
	9 - Exit\n\n"
	read -p "Which version of PCSX2 would you like to install? " choice02

	case $choice02 in
		1 ) echo 'Installing BIOS files...';
			addbios
			break;;
		2 ) echo 'Adding Roms....';
			addroms
			break;;
		3 ) echo 'Configuring Network....';
			networking
			break;;
		4 ) echo 'Configuring Graphics....';
			configgraphics;
			break;;
		5 ) echo 'Ok, running PCSX2.';
			clear;
			printf "%-4s \n1 - flatpak\n2 - apt\n3 - return home\n";
			read -p "Flatpak or apt? " yn6;
			case $yn6 in
				1 ) clear;
					launchpcsx2flatpak
					break;;
				2 ) clear;
					launchpcsx2apt
					break;;
				3 ) clear;
					main
					break;;
				* ) echo 'Invalid input';
					main
					break;;
			esac
			break;;
		6 ) echo 'Opening file explorer....';
			nautilus $HOME/.var/app/net.pcsx2.PCSX2;
			break;;
		7 ) echo 'Viewing Roms';
				if [[! -d "$HOME/.var/app/net.pcsx2.PCSX2/roms"]];
				then
					read -t 7 -N 1 'echo "The roms folder currently does not exist"'
					configmenu
				else
					ls -lahr $HOME/.var/app/net.pcsx2.PCSX2/roms
					read -t 7 -N 1 -e "/n"
					configmenu
				fi
			break;;
		8 ) main;
			break;;
		9 ) echo 'Exit';
			clear;
			read -p 'Are you sure you want to exit? [Y/N] ' yn
				case $yn in
					[Yy] ) echo 'Exiting...';
						clear;
						exit;;
					[Nn] ) echo 'Returning...';
						clear;
						main
						break;;
				esac
			break;;
		* ) echo 'invalid response';
		    clear;
		    configmenu
		    break;;
	esac
}

# explore directory here

# configuration methods here for flatpak
<<COMMENT
function configgraphics () {

}

function networking () {

}

COMMENT

function addroms () {
	read -p "Enter the Directory in which your roms are stored to be copied over to the install directory: " enterRoms

	echo $enterRoms
	echo $HOME
	read -p "Is this the correct directory? [Y/N]" yn7

	case $yn7 in
		[Yy] ) echo 'Working...';
			if [[ ! -d "$HOME/.var/app/net.pcsx2.PCSX2/roms" ]];
			then
				# $RecusrivePathsGames = cat $HOME/.var/app/net.pcsx2.PCSX2/config/PCSX2/inis/PCSX2.ini | grep -o "[GameList]" || grep -o "RecursivePaths"
				sudo mkdir $HOME/.var/app/net.pcsx2.PCSX2/roms ; sudo cp -r "$enterRoms" $HOME/.var/app/net.pcsx2.PCSX2/roms ; sudo sed -i "405 i /[GameList]/406 i RecursivePaths = $HOME/.var/app/net.pcsx2.PCSX2/roms" $HOME/.var/app/net.pcsx2.PCSX2/config/PCSX2/inis/PCSX2.ini
			else
				sudo cp -r "$enterRoms" "$HOME/.var/app/net.pcsx2.PCSX2/roms" ; sudo sed -i "405 i /[GameList]/406 i RecursivePaths = $HOME/.var/app/net.pcsx2.PCSX2/roms" $HOME/.var/app/net.pcsx2.PCSX2/config/PCSX2/inis/PCSX2.ini
			fi
			configmenu
			break;;
		[Nn] ) 
			addroms
			break;;
	esac

}

function addbios () {
	read -p "Would you like to enter the path for your Bios(es)? [Y/N] " yn3

	case $yn3 in
		[yY] ) echo 'Please enter the path for your BIOS';
			read -p 'Enter Path to File(s): ' biospath;
			sudo cp -r '$biospath' '$HOME/.var/app/net.pcsx2.PCSX2/config/PCSX2/bios';
			exit;;
		[nN] ) echo 'Bye!';
			exit;;
		* ) echo "Exiting..";
			exit;;
	esac

}

# configuration methods for apt.

# Launch methods here for flatpak and apt.

function launchpcsx2apt () {
	echo "would you like to Run PCSX2?:
	1 - Run PCSX2
	2 - return back to main menu " 
	read -p 'Enter: ' c12

	case $c12 in
		1 ) "Running....";
			break;;
		2 ) echo 'returning...'
		main
		break;;
		* ) echo "Invalid input."
			launchpcsx2apt
	esac

}


function launchpcsx2flatpak () {
	read -p "would you like to Run PCSX2? [Y/N]" yn4
	
	case $yn4 in
		[yY] ) echo 'launching...';
			(flatpak run net.pcsx2.PCSX2 &) && exit;;
		[nN] ) echo "Loading main menu....";
			main;;
		* ) echo "invalid.";
		launchpcsx2flatpak;;
	esac
}


# All Installation methods are here.

function install_flatpak () {
    sudo apt install ca-certificates -y ; sudo apt install flatpak -y ; sudo apt install gnome-software-plugin-flatpak ; flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    install_pcsx2viaflatpak
}


function install_pcsx2viaapt () {
	sudo apt install pcsx2 -y
	main
}

function install_pcsx2viaflatpak () {

    echo 'Installing PCSX2 now via Flatpak....';
    sudo flatpak install net.pcsx2.PCSX2 -y;
	main

}

main


