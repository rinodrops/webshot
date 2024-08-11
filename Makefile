# Makefile for webshot

# Default to system-wide installation
SYSTEM_WIDE ?= 1

ifeq ($(SYSTEM_WIDE),1)
    INSTALL_PATH ?= /opt/webshot
    BIN_PATH ?= /usr/local/bin
    SUDO = sudo
else
    INSTALL_PATH ?= $(HOME)/.local/opt/webshot
    BIN_PATH ?= $(HOME)/.local/bin
    SUDO =
endif

VENV_PATH = $(INSTALL_PATH)/venv

.PHONY: all build install clean uninstall

all: build

build:
	@echo "Creating virtual environment..."
	python3 -m venv $(VENV_PATH)

	@echo "Installing required packages..."
	$(VENV_PATH)/bin/pip install -r requirements.txt

install: build
	@echo "Installing webshot..."
	$(SUDO) mkdir -p $(INSTALL_PATH)
	$(SUDO) cp webshot.py $(INSTALL_PATH)/

	@echo "Creating wrapper script..."
	@echo '#!/bin/bash' | $(SUDO) tee $(BIN_PATH)/webshot > /dev/null
	@echo 'source $(VENV_PATH)/bin/activate' | $(SUDO) tee -a $(BIN_PATH)/webshot > /dev/null
	@echo 'python $(INSTALL_PATH)/webshot.py "$$@"' | $(SUDO) tee -a $(BIN_PATH)/webshot > /dev/null
	@echo 'deactivate' | $(SUDO) tee -a $(BIN_PATH)/webshot > /dev/null

	$(SUDO) chmod +x $(BIN_PATH)/webshot

	@echo "Installation complete. You can now run 'webshot' from anywhere."
	@if [ "$(SYSTEM_WIDE)" != "1" ]; then \
		echo "Make sure $(BIN_PATH) is in your PATH."; \
	fi

clean:
	@echo "Cleaning build artifacts..."
	rm -rf $(VENV_PATH)

uninstall:
	@echo "Uninstalling webshot..."
	$(SUDO) rm -rf $(INSTALL_PATH)
	$(SUDO) rm -f $(BIN_PATH)/webshot
	@echo "Uninstall complete."
