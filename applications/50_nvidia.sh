# NVIDIA settings
if $ARCH; then
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
fi

if $FEDORA; then
    nvidia_pkg=(
        akmod-nvidia
        xorg-x11-drv-nvidia-cuda
        libva
        libva-nvidia-driver
    )

    nvidia_services=(
        nvidia-suspend.service
        nvidia-hibernate.service
        nvidia-resume.service
    )

    # Install additional Nvidia packages
    for package in "${nvidia_pkg[@]}"; do
        if ! is_package_installed "$package"; then
            install_package "$package"
            if [ $? -ne 0 ]; then
                log "ERROR" "$package Installation failed. Check the install log."
                exit 1
            fi
        fi
    done

    log "WARNING" "Adding nvidia-stuff to /etc/default/grub..."

    # Additional options to add to GRUB_CMDLINE_LINUX
    additional_options="rd.driver.blacklist=nouveau modprobe.blacklist=nouveau nvidia-drm.modeset=1 nvidia_drm.fbdev=1"

    # Check if additional options are already present in GRUB_CMDLINE_LINUX
    if grep -q "GRUB_CMDLINE_LINUX.*$additional_options" /etc/default/grub; then
        echo "GRUB_CMDLINE_LINUX already contains the additional options"
    else
        # Append the additional options to GRUB_CMDLINE_LINUX
        sudo sed -i "s/GRUB_CMDLINE_LINUX=\"/GRUB_CMDLINE_LINUX=\"$additional_options /" /etc/default/grub
        echo "Added the additional options to GRUB_CMDLINE_LINUX"
    fi

    # Update GRUB configuration
    sudo grub2-mkconfig -o /boot/grub2/grub.cfg

    for service in "${nvidia_services[@]}"; do
        sudo systemctl enable "$service"
        if [ $? -ne 0 ]; then
            log "ERROR" "$service could not be activated. Check the install log."
            exit 1
        fi
    done

    log "CINFO" "Nvidia DRM modeset and additional options have been added to /etc/default/grub. Please reboot for changes to take effect."
fi
