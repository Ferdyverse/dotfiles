#!/bin/bash

packages=(
    nvidia-dkms
    nvidia-utils
    lib32-nvidia-utils
    nvidia-settings
    libva-nvidia-driver
)

for package in "${packages[@]}"; do
    if ! is_package_installed "$package"; then
        install_package "$package"
    fi
done

echo "force_drivers+=\" nvidia nvidia_modeset nvidia_uvm nvidia_drm \"" | sudo tee -a /etc/dracut.conf.d/nvidia.conf
echo "options nvidia_drm modeset=1 fbdev=1" | sudo tee -a /etc/modprobe.d/nvidia.conf

sudo dracut-rebuild
sudo grub-mkconfig -o /boot/grub/grub.cfg
