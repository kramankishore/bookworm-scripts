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

### Step 4: Install git, micro, zram-tools & configure zram
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

### Step 5: Install bspwm and personalise it
```
git clone https://github.com/kramankishore/bookworm-scripts
cd bookworm-scripts
./installer.sh
./custom.sh
./teal.sh
```

Then reboot
Upon reboot, you should see the lightdm login manager. On top right you can change from default option to bspwm before logging in.

### Step 6: Network Manager configuration
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

After that, on checking with the command 'nmcli dev', the status of wifi device changed from 'unmanaged' to 'unavailable'
I was unable to solve this problem for a long time. No matter what I did, 'unavailable' was not changing to available.
And because of this, in the top right icon in polybar (nm-applet), I was not able to see any wifi options and unable to connect to wifi.

However, after a shutdown, it started working finally! Not sure how. Finally, if I click the top right icon, wifi was available and I was able to scan the existing networks and connect to my wifi.
It may be possible that I pressed random buttons on keyboard and enabled wifi via some hotkey? Not sure!


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
