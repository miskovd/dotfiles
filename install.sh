#/bin/bash
# echo -e "\e[1;30m   I N S T A L L"
# echo -e "\e[1;34m I N S T A L L\e[0m"

echo "####:'##::: ##::'######::'########::::'###::::'##:::::::'##:::::::"
echo ". ##:: ###:: ##:'##... ##:... ##..::::'## ##::: ##::::::: ##:::::::"
echo ": ##:: ####: ##: ##:::..::::: ##:::::'##:. ##:: ##::::::: ##:::::::"
echo ": ##:: ## ## ##:. ######::::: ##::::'##:::. ##: ##::::::: ##:::::::"
echo ": ##:: ##. ####::..... ##:::: ##:::: #########: ##::::::: ##:::::::"
echo ": ##:: ##:. ###:'##::: ##:::: ##:::: ##.... ##: ##::::::: ##:::::::"
echo "'####: ##::. ##:. ######::::: ##:::: ##:::: ##: ########: ########:"
echo "....::..::::..:::......::::::..:::::..:::::..::........::........::"

# ----------------------------------------------------- 
# Installation of required packages
# ----------------------------------------------------- 

installer_packages=(
    "wget"
    "unzip"
    "git"
    "dhcpcd"
    "iwd"
    "networkmanager"
)
sudo pacman -Sy

systemctl enable dhcpcd
systemctl enable iwd
systemctl enable dhcpcd@wlan0.service
systemctl start dhcpcd@wlan0.service
systemctl start NetworkManager.service
systemctl enable NetworkManager.service





# Install required packages
_installPackages() {
    toInstall=();
    for pkg; do
        if [[ $(_isInstalled "${pkg}") == 0 ]]; then
            echo "${pkg} is already installed.";
            continue;
        fi;
        toInstall+=("${pkg}");
    done;
    if [[ "${toInstall[@]}" == "" ]] ; then
        # echo "All pacman packages are already installed.";
        return;
    fi;
    printf "Package not installed:\n%s\n" "${toInstall[@]}";
    sudo pacman --noconfirm -S "${toInstall[@]}";
}

_installPackagesYay() {
    toInstall=();
    for pkg; do
        if [[ $(_isInstalledYay "${pkg}") == 0 ]]; then
            echo ":: ${pkg} is already installed.";
            continue;
        fi;
        toInstall+=("${pkg}");
    done;

    if [[ "${toInstall[@]}" == "" ]] ; then
        # echo "All packages are already installed.";
        return;
    fi;

    # printf "AUR packags not installed:\n%s\n" "${toInstall[@]}";
    yay --noconfirm -S "${toInstall[@]}";
}

# Install required packages
echo ":: Checking that required packages are installed..."
_installPackages "${installer_packages[@]}";


# ----------------------------------------------------- 
# Install packages 
# ----------------------------------------------------- 

installer_packages=(
    "hyprland"
    "waybar"
    "wofi"
    "alacritty"
    "dunst"
    #"thunar" light file manager
    "xdg-desktop-portal-hyprland"
    "qt5-wayland"
    "qt6-wayland"
    #"hyprpaper"
    #"hyprlock"
    "firefox"
    "ttf-font-awesome"
    "otf-font-awesome"
    #"ttf-jetbrains-mono-nerd"
    #"ttf-nerd-fonts-symbols"
    "vim"
    "fastfetch"
    #"ttf-fira-sans" 
    #"ttf-fira-code" 
    #"ttf-firacode-nerd"
    "gtk4"
    "pavucontrol"
    "alsa-utils"
    "ranger"
    "bluez"
    "bluez-utils"
    "mvp"
    #"vlc"
    
)

installer_yay=(
    "wlogout" 
)

# PLEASE NOTE: Add more packages at the end of the following command
_installPackages "${installer_packages[@]}";
#_installPackagesYay "${installer_yay[@]}";


# Install Pywal - change system colors from bg image
#TODO
# Init Pywal
#wal -i ~/dotfiles/default.jpg
#echo "Pywal - initiated"
#_installSymlink alacritty ~/.config/alacritty ...