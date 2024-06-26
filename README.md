# Notes by Raman
I have updated the scripts to keep only bspwm (& related) installation.
To install this whole thing, the steps are:

### Step 1: Download debian 12.5 ISO file (debian-12.5.0-amd64-netinst.iso)
Currently, I can see the download link at https://www.debian.org/download

### Step 2: Make a bootable USB drive with this ISO file
```
sudo dd if=/path/to/iso of=/usb/drive/path bs=1M status=progress
```

The usb drive path is usually something like /dev/sdb. Plug in the usb drive and use the command lsblk to check this.
Sometimes you might have to umount (unmount) the usb drive before writing the iso file to it. Google if you face issues.

Once installation is done, you can boot into debian.

### Step 3 (Optional): Configure the terminal to make it look bigger
```
sudo dpkg-reconfigure console-setup
```

Select the exisiting options (like UTF-8 -> Latin1 and Latin5 (default option) -> Then select Terminus -> Then select the last or last second font size

### Step 4: Add non-free and contrib to sources list

```
sudo micro /etc/apt/sources.list
```

Add 'non-free contrib' to all lines. So this changed the sources.list file from:
```
#deb cdrom:[Debian GNU/Linux 12.5.0 _Bookworm_ - Official amd64 NETINST with firmware 20240210-11:27]/ bookworm contrib main non-free-firmware

deb http://deb.debian.org/debian/ bookworm main non-free-firmware
deb-src http://deb.debian.org/debian/ bookworm main non-free-firmware

deb http://security.debian.org/debian-security bookworm-security main non-free-firmware
deb-src http://security.debian.org/debian-security bookworm-security main non-free-firmware

# bookworm-updates, to get updates before a point release is made;
# see https://www.debian.org/doc/manuals/debian-reference/ch02.en.html#_updates_and_backports
deb http://deb.debian.org/debian/ bookworm-updates main non-free-firmware
deb-src http://deb.debian.org/debian/ bookworm-updates main non-free-firmware

# This system was installed using small removable media
# (e.g. netinst, live or single CD). The matching "deb cdrom"
# entries were disabled at the end of the installation process.
# For information about how to configure apt package sources,
# see the sources.list(5) manual.
```

And changed it to the following by adding 'non-free contrib':
```
#deb cdrom:[Debian GNU/Linux 12.5.0 _Bookworm_ - Official amd64 NETINST with firmware 20240210-11:27]/ bookworm contrib main non-free-firmware

deb http://deb.debian.org/debian/ bookworm main non-free-firmware non-free contrib
deb-src http://deb.debian.org/debian/ bookworm main non-free-firmware non-free contrib

deb http://security.debian.org/debian-security bookworm-security main non-free-firmware non-free contrib
deb-src http://security.debian.org/debian-security bookworm-security main non-free-firmware non-free contrib

# bookworm-updates, to get updates before a point release is made;
# see https://www.debian.org/doc/manuals/debian-reference/ch02.en.html#_updates_and_backports
deb http://deb.debian.org/debian/ bookworm-updates main non-free-firmware non-free contrib
deb-src http://deb.debian.org/debian/ bookworm-updates main non-free-firmware non-free contrib

# This system was installed using small removable media
# (e.g. netinst, live or single CD). The matching "deb cdrom"
# entries were disabled at the end of the installation process.
# For information about how to configure apt package sources,
# see the sources.list(5) manual.
```

And then:
```
sudo apt update
sudo apt upgrade
```

### Step 5: Install git, micro, zram-tools & configure zram
```
sudo apt install git micro zram-tools
sudo micro /etc/default/zramswap
```

Uncomment the below two lines & save the file:
```
ALGO=lz4
PERCENT=50
```

You can change the percent to 25 as well

Restart zramswap.service

```
sudo systemctl restart zramswap.service
```

### Step 6: Install bspwm and personalise it
```
git clone https://github.com/kramankishore/bookworm-scripts
cd bookworm-scripts
./installer.sh
./custom.sh
./teal.sh
```

Then reboot
Upon reboot, you should see the lightdm login manager. On top right you can change from default option to bspwm before logging in.

### Step 7: Network Manager configuration
I am still not sure how this worked! It somehow worked after so many attempts.
network-manager & network-manager-gnome should be installed with the above scripts.
nm-applet command should add the applet icon in top right of polybar (this should be seen by default).
On checking the status with the command 'nmcli dev', I was seeing the wifi in 'unmanaged' state.
I updated NetworkManager.conf

```
sudo micro /etc/NetworkManager/NetworkManager.conf
```

Changed the text of the file from:
```
[main]
plugins=ifupdown,keyfile

[ifupdown]
managed=false
```

to:
```
[main]
plugins=ifupdown,keyfile

[ifupdown]
managed=true
```

And restarted the network manager by running the command:
```
sudo systemctl restart NetworkManager
```

Then rebooted the machine:
```
sudo reboot
```

Also, installed this (not sure how much it helped):
```
sudo apt-get install firmware-iwlwifi
```


After that, on checking with the command 'nmcli dev', the status of wifi device changed from 'unmanaged' to 'unavailable'
I was unable to solve this problem for a long time. No matter what I did, 'unavailable' was not changing to available.
And because of this, in the top right icon in polybar (nm-applet), I was not able to see any wifi options and unable to connect to wifi.

However, after a shutdown, it started working finally! Not sure how. Finally, if I click the top right icon, wifi was available and I was able to scan the existing networks and connect to my wifi.
Even after this, it did not work reliably. It used to work few times and then not work few other times and I had to keep rebooting.

On digging deeper, I realised I can check NetworkManager errors by journalctl command:
Ref: https://forum.manjaro.org/t/wifi-connection-shows-device-not-ready-tried-everything-please-help/117957/3

```
sudo journalctl --boot 0 --unit NetworkManager --no-pager
```

On checking this, I saw the error:
```
Jun 10 02:10:30 raman-gc NetworkManager[813]: <error> [1717965630.8922] device (wlp3s0): Couldn't initialize supplicant interface: GDBus.Error:fi.w1.wpa_supplicant1.UnknownError: wpa_supplicant couldn't grab this interface.
Jun 10 02:10:30 raman-gc NetworkManager[813]: <info>  [1717965630.8923] device (wlp3s0): supplicant interface keeps failing, giving up
```

On googling this error, I landed on this - Ref: https://forums.debian.net/viewtopic.php?p=751848#p751848
From this, I realised that the following commands can make it work:
```
sudo systemctl unmask wpa_supplicant.service
sudo systemctl restart NetworkManager
sudo systemctl restart wpa_supplicant.service
sudo systemctl restart wpa_supplicant
```

#### rofi-network-manager
Also, this whole installation adds a script called ~/bin/rofi-network-manager
This can be triggered with the shortcut
```
super + n
```

This is rofi style network manager (works on top on NetworkManager)

### Step 8: Install Slack & Todoist
Slack:
Ref: https://slack.com/intl/en-in/downloads/linux
Don't download from the snap store
Check if there is a .deb app link

Todoist:
For todoist, I have installed using AppImageLauncher.
Go to - https://todoist.com/downloads/linux
and click "Go here for instructions"

First, install appimagelauncher. Ref: https://github.com/TheAssassin/AppImageLauncher/releases
I tried appimagelauncher lite first but it did not work. Then I installed the full version and it worked.

After installing appimagelauncher, you will have access to ail-cli command. Then, download Todoist's appimage file & run:
```
ail-cli integrate <path to todoist appimage file>
```

Once Todoist is integrated, you should be able to launch it from rofi.

### Step 9: Activate tap to click on touchpad
Ref: https://unix.stackexchange.com/a/337218

Remove the package - `xserver-xorg-input-synaptics`
```
sudo apt remove xserver-xorg-input-synaptics
```

Install `xserver-xorg-input-libinput`
```
sudo apt install xserver-xorg-input-libinput
```

Create directory /etc/X11/xorg.conf.d
```
mkdir /etc/X11/xorg.conf.d
```

For me the above 3 commands did not make any change since synaptics package was already not present, libinput package was already present and `/etc/X11/xorg.conf.d` directory was already present too.

Then, create the file:
```
sudo micro /etc/X11/xorg.conf.d/40-libinput.conf
```

And all the following content in the file:
```
Section "InputClass"
        Identifier "libinput touchpad catchall"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
        Option "Tapping" "on"
EndSection
```

Then, restart the login manager:
```
sudo systemctl restart lightdm
```
### Step 10: Install Betterlockscreen
Reference: https://github.com/betterlockscreen/betterlockscreen

Install the dependencies first - i3lock-color & ImageMagick

## End of Raman's notes

# bookworm-scripts

### installer.sh
Assuming you have already installed a minimal Debian 12 install.
The series of shell scripts are intended to facilitate installing popular window managers.

Within the installer.sh file, you can choose to install the following window managers:
* bspwm
* dk 
* dwm
* qtile
* i3

**Uncomment the lines in the bash script to enable installation.**

#### With regard to other scripts:
* custom.sh - installs my current configurations for all window managers.
* discord-install.sh - installs the newest discord quickly from the current binary files.
* lapce.sh - installs the alpah version of the Lapce text editor.  
* ly.sh - installs the ly console manager (careful if you already have lightdm installed)
* neovim.sh - neovim in the Debian packages is somewhat dated.  This installs the newest from github.
* orchis.sh - installs some gtk themes and icons for your gui.
* teal.sh - installs teal colored gtk theme and icon set
* blue.sh - installs blue colored gtk theme and icon set
* thunderbird_install.sh - installs the newest thunderbird on Debian.

### NEW sway-install.sh added
Recently, I have been thinking about getting a jump on adding a window manager for Wayland.  Fortunately, there is a good "compositor" for this purpose.
Added scripts:

* sway-install.sh
* custom-sway.sh - replaces the default configuration files with my own.
* nwg-look - installs an lxappearance program to use GTK themes and icons in Wayland.
* rofi-wayland - designed to behave like rofi(xorg) but in Wayland.
