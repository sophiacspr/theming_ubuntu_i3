LOCAL_PREFIX = $(HOME)/.local/bin
THEME_DIR = $(HOME)/.config/theme

i3CONFIG_STANDARD_DIR = $(HOME)/.config/i3
i3CONFIG_BLOCKS_DIR = $(HOME)/.config/i3blocks
DOCK_SCRIPT_TARGET = /usr/local/bin/docking_layout.sh
DOCK_UDEV_RULE_TARGET = /etc/udev/rules.d/99-dock-layout.rules

SCRIPTS = theme-yazi theme-vscode theme-rofi theme-i3-colors i3-build-config theme-micro theme-flameshot
i3SCRIPTS = theme-i3-colors i3-build-config

THEME_CONFIGS = font.json palette.json syntax.json

.PHONY: install install-i3 clean yazi vscode rofi i3 micro flameshot retheme-all retheme-i3 vis-palette install-dock-script

# Install script for the docking station recognition
install-dock-script:
	sudo ln -sf $(CURDIR)/udev_rules/dock/layout.sh $(DOCK_SCRIPT_TARGET)
	sudo chmod +x $(DOCK_SCRIPT_TARGET)
	sudo ln -sf $(CURDIR)/udev_rules/dock/99-dock-layout.rules $(DOCK_UDEV_RULE_TARGET)
	sudo udevadm control --reload
	sudo udevadm trigger


# Install the color palettes and fonts configurations
install-themes:
	@mkdir -p $(THEME_DIR)
	@for c in $(THEME_CONFIGS); do \
	  ln -sf $(CURDIR)/themes/$$c $(THEME_DIR)/$$c; \
	done
	@echo "Installed themes files into $(THEME_DIR)"
	@chmod +x $(CURDIR)/themes/visualize_colors
	@$(CURDIR)/themes/visualize_colors || true

# Install the required files for i3, i3blocks
install-i3: install-themes
# i3 base config and helper scripts
	@mkdir -p $(i3CONFIG_STANDARD_DIR)
	@ln -sf $(CURDIR)/i3/i3_standard/config.base $(i3CONFIG_STANDARD_DIR)/config.base
	@for f in $(CURDIR)/i3/i3_standard/*.sh; do \
	  ln -sf $$f $(i3CONFIG_STANDARD_DIR)/$$(basename $$f); \
	  chmod +x $$f; \
	done
	@echo "Installed i3 standard config files into $(i3CONFIG_STANDARD_DIR)"
# i3 blocks and helper scripts
	@ln -sf $(CURDIR)/i3/i3_blocks/config $(i3CONFIG_BLOCKS_DIR)/config
	@for f in $(CURDIR)/i3/i3_blocks/*.sh; do \
	  ln -sf $$f $(i3CONFIG_BLOCKS_DIR)/$$(basename $$f); \
	  chmod +x $$f; \
	done
	@echo "Installed i3blocks config files into $(i3CONFIG_BLOCKS_DIR)"
# i3 update colors scripts
	@mkdir -p $(LOCAL_PREFIX)
	@for s in $(i3SCRIPTS); do \
	  ln -sf $(CURDIR)/scripts/$$s $(LOCAL_PREFIX)/$$s; \
	  chmod +x $(CURDIR)/scripts/$$s; \
	done
	@echo "Installed scripts and themes for i3."

# Install scripts for theming of rofi, vs code, flameshot, ... and the i3 config
install: install-themes install-i3
	@mkdir -p $(LOCAL_PREFIX)
	@for s in $(SCRIPTS); do \
	  ln -sf $(CURDIR)/scripts/$$s $(LOCAL_PREFIX)/$$s; \
	  chmod +x $(CURDIR)/scripts/$$s; \
	done
	@echo "Installed scripts and themes for wezterm, yazi, vs code, ... into $(LOCAL_PREFIX)"

# Clean symlinks + wrapper
clean:
	@for s in $(SCRIPTS); do \
	  rm -f $(LOCAL_PREFIX)/$$s; \
	done
	@for c in $(THEME_CONFIGS); do \
	  rm -f $(THEME_DIR)/$$c; \
	done
	@rm -f $(THEME_DIR)/palette_preview.png
	@rm -f $(i3CONFIG_STANDARD_DIR)/config.base
	@rm -f $(i3CONFIG_STANDARD_DIR)/colors.i3
	@for f in $(CURDIR)/i3/i3_standard/*.sh; do \
	  rm -f $(i3CONFIG_STANDARD_DIR)/$$(basename $$f); \
	done
	@rm -f $(i3CONFIG_BLOCKS_DIR)/config
	@for f in $(CURDIR)/i3/i3_blocks/*.sh; do \
	  rm -f $(i3CONFIG_BLOCKS_DIR)/$$(basename $$f); \
	done
	rm -f $(DOCK_SCRIPT_TARGET)
	rm -f $(DOCK_UDEV_RULE_TARGET)
	@echo "Removed installed scripts into $(LOCAL_PREFIX), theme files from $(THEME_DIR) and i3 config files from $(i3CONFIG_STANDARD_DIR) and $(i3CONFIG_BLOCKS_DIR) and docking station config files."

# Individual targets (call installed scripts)
yazi:
	$(LOCAL_PREFIX)/theme-yazi

vscode:
	$(LOCAL_PREFIX)/theme-vscode

rofi:
	$(LOCAL_PREFIX)/theme-rofi

i3:
	$(LOCAL_PREFIX)/theme-i3-colors
	$(LOCAL_PREFIX)/i3-build-config

micro:
	$(LOCAL_PREFIX)/theme-micro

flameshot:
	$(LOCAL_PREFIX)/theme-flameshot

retheme-all: yazi vscode rofi i3 micro flameshot
	@command -v i3-msg >/dev/null && i3-msg reload >/dev/null || true
	@command -v wezterm >/dev/null && wezterm cli reload >/dev/null 2>&1 || true
	@echo "Retheming finished."

retheme-i3: i3
	@command -v i3-msg >/dev/null && i3-msg reload >/dev/null || true
	@echo "i3 retheming finished."

vis-palette:
	@chmod +x $(CURDIR)/themes/visualize_colors
	@$(CURDIR)/themes/visualize_colors || true

