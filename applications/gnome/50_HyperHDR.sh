# HyperHDR is used for my monitor ambient lights
if ! is_package_installed "hyperhdr"; then
    cd /tmp
    wget -qO- https://awawa-dev.github.io/hyperhdr.public.apt.gpg.key | gpg --dearmor >hyperhdr.public.apt.gpg.key 
    cat hyperhdr.public.apt.gpg.key | sudo tee /usr/share/keyrings/hyperhdr.public.apt.gpg.key >/dev/null
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hyperhdr.public.apt.gpg.key] https://awawa-dev.github.io $(lsb_release -cs) main" | 
        sudo tee /etc/apt/sources.list.d/hyperhdr.list
    update_cache
    rm hyperhdr.public.apt.gpg.key
    install_package hyperhdr
    cd -
fi