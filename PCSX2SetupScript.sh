#!/bin/bash

#config menu here

# Main function here.

function main () {
	clear
	echo "Install one of the following versions of PCSX2:
	1 - Install apt version.
	2 - Install Flatpak version.
	3 - Install Flatpak along with PCSX2.
	4 - Configurations Menu
	5 - Run PCSX2
	6 - Exit"
	read -p "Which version of PCSX2 would you like to install?" choice01
	
	case $choice01 in
		1 ) echo 'Ok, installing apt version of PCSX2.';
			install_pcsx2viaapt
			break;;
		2 ) echo 'Ok, installing the Flatpak version of PCSX2.';
			install_pcsx2viaflatapak
			break;;
		3 ) echo 'Ok, Installing Flatpak with PCSX2.';
			install_flatpak;
			break;;
		4 ) echo 'Ok, choosing the config menu. ';
			configmenu;;
		5 ) echo 'Ok, running PCSX2.';
			read -p 'Flatpak or apt?
			1 - flatpak
			2 - apt
			3 - return home' yn6
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
	echo "Install one of the following versions of PCSX2:
	1 - Add BIOS files
	2 - Add ROMS
	3 - Configure Network
	4 - Graphics
	5 - Run PCSX2
	6 - Exit"
	read -p "Which version of PCSX2 would you like to install?" choice02

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
			read -p 'Flatpak or apt?
			1 - flatpak
			2 - apt
			3 - return home' yn6
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
		    configmenu
		    break;;
	esac
}

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
				sudo mkdir $HOME/.var/app/net.pcsx2.PCSX2/roms ; sudo cp -r $enterRoms $HOME/.var/app/net.pcsx2.PCSX2/roms ; sudo sed -i 's/RecursivePaths =/$enterRoms/g' $HOME/.var/app/net.pcsx2.PCSX2/config/PCSX2/inis/PCSX2.in
			else
				sudo cp -r $enterRoms $HOME/.var/app/net.pcsx2.PCSX2/roms ; sudo sed -i 's/RecursivePaths =/$enterRoms/g' $HOME/.var/app/net.pcsx2.PCSX2/config/PCSX2/inis/PCSX2.ini
			fi
			configmenu
			break;;
		[Nn] ) addroms;
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


