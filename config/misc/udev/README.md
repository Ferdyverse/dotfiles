# Readme for udev rules

To use a udev rule just link via `ln` to the folder for custom rules. Normally this is the following folder `/etc/udev/rules.d/`.

```bash
ln -s $(pwd)/<RULEFILE> /etc/udev/rules.d/<RULEFILE>

# Reoad rules
sudo udevadm control --reload
sudo udevadm trigger
```
