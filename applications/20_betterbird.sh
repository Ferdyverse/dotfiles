if [[ "$BASE_DISTRO" =~ ^(fedora|arch) ]]; then
  is_package_installed "betterbird" || install_package betterbird
fi
