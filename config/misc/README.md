# Misc folder

In this folder are some files stored I often require for my setup but not need on every device.

## udev

The files inside of the `udev` subfolder should be copied into `/etc/udev/rules.d/` to be executed.

```bash
sudo ln -s /home/bergefe/.dotfiles/config/misc/udev/50-usb_power_save.rules /etc/udev/rules.d/50-usb_power_save.rules
sudo ln -s /home/bergefe/.dotfiles/config/misc/udev/99-dimensions.rules /etc/udev/rules.d/99-dimensions.rules
sudo ln -s /home/bergefe/.dotfiles/config/misc/udev/99-escpos.rules /etc/udev/rules.d/99-escpos.rules
sudo ln -s /home/bergefe/.dotfiles/config/misc/udev/99-esp.rules /etc/udev/rules.d/99-esp.rules

# After adding a new rule you can apply it like this
sudo udevadm control --reload
```
