#!/bin/bash

xfce_set_wallpaper() {
    image=$1
    properties=$(xfconf-query -c xfce4-desktop -l)

    while IFS= read -r property
    do
        if [[ $property = /backdrop/* ]] && [[ $property = *last-image* ]]
        then
            xfconf-query -c xfce4-desktop -p "$property" -s "$image"
        fi
    done <<< "$properties"
}

xfce_set_style() {
    style=$1
    properties=$(xfconf-query -c xfce4-desktop -l)

    while IFS= read -r property
    do
        if [[ $property = /backdrop/* ]] && [[ $property = *image-style* ]]
        then
            xfconf-query -c xfce4-desktop -p "$property" -s "$style"
        fi
    done <<< "$properties"
}

xfce_prop_set() {
    xfconf-query -c $1 -p $2 -s $3
}

# refresh font cache
fc-cache -fv

# Add yadyn to cron
cron_job="0 * * * * /usr/bin/yadyn /home/$(whoami)/.yadyntheme/thatch/yadyn.cfg > ~/yadyn-cron.log"
(crontab -l 2>/dev/null; echo "$cron_job") | crontab -

# Do a manual yadyn run
yadyn /home/$(whoami)/.yadyntheme/thatch/yadyn.cfg

# Update the wallpaper
xfce_set_wallpaper /home/$(whoami)/.yadyn-buffer.png

# Set image style to tiled
xfce_set_style 2

# Set panel 2 length to minimum
xfce_prop_set xfce4-panel /panels/panel-2/length 1.000000

# Set length adjust property of panel 2 to true
xfce_prop_set xfce4-panel /panels/panel-2/length-adjust true

# Set GTK theme (style)
xfce_prop_set xsettings /Net/ThemeName xfce4-chicago95

# Set icon theme
xfce_prop_set xsettings /Net/IconThemeName os9

# Set GTK font
xfce_prop_set xsettings /Gtk/FontName "Windows Bold 13"

# Set XFWM theme (window decorations)
xfce_prop_set xfwm4 /general/theme PlatiPlus26

# Set XFWM font (window title font)
xfce_prop_set xfwm4 /general/title_font "Charcoal Bold 10"

# We finished here, so let's delete the autorun script
rm ~/.config/autostart/mydevuan-postinstall.desktop

# Delete the script
rm -- "$0"

# Exit
exit 0