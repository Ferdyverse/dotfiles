# Makefile in ~/.dotfiles

# Default script
BOOTSTRAP := ./bootstrap.sh

.PHONY: all work update run-gnome run-hyprland help

all:
	$(BOOTSTRAP)

work:
	$(BOOTSTRAP) --work

run-hyprland:
	@echo "Running Hyprland setup"
	$(BOOTSTRAP) --file applications/hyprland_install.sh

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  all           Run full bootstrap"
	@echo "  work          Run work setup"
	@echo "  run-hyprland  Run Hyprland-specific setup"
