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

VENV_NAME = venv

.PHONY: all build install clean uninstall dist

all: build

build:
	@echo "Creating virtual environment..."
	python3 -m venv $(VENV_NAME)
	@echo "Installing required packages..."
	./$(VENV_NAME)/bin/pip install -r requirements.txt

install:
	@echo "Installing webshot..."
	$(SUDO) mkdir -p $(INSTALL_PATH)
	$(SUDO) cp -R $(VENV_NAME) $(INSTALL_PATH)/ 2>/dev/null || :
	$(SUDO) cp webshot.py $(INSTALL_PATH)/
	@echo "Creating wrapper script..."
	@echo '#!/bin/bash' | $(SUDO) tee $(BIN_PATH)/webshot > /dev/null
	@echo 'source $(INSTALL_PATH)/$(VENV_NAME)/bin/activate' | $(SUDO) tee -a $(BIN_PATH)/webshot > /dev/null
	@echo 'python $(INSTALL_PATH)/webshot.py "$$@"' | $(SUDO) tee -a $(BIN_PATH)/webshot > /dev/null
	@echo 'deactivate' | $(SUDO) tee -a $(BIN_PATH)/webshot > /dev/null
	$(SUDO) chmod +x $(BIN_PATH)/webshot
	@echo "Installation complete. You can now run 'webshot' from anywhere."
	@if [ "$(SYSTEM_WIDE)" != "1" ]; then \
		echo "Make sure $(BIN_PATH) is in your PATH."; \
	fi

clean:
	@echo "Cleaning build artifacts..."
	rm -rf $(VENV_NAME)

uninstall:
	@echo "Uninstalling webshot..."
	$(SUDO) rm -rf $(INSTALL_PATH)
	$(SUDO) rm -f $(BIN_PATH)/webshot
	@echo "Uninstall complete."

dist:
	@if ! command -v git >/dev/null 2>&1; then \
		echo "Error: git is not installed. The dist target requires git for versioning."; \
		exit 1; \
	fi
	@if [ -z "$(shell git status --porcelain)" ]; then \
		VERSION=$$(git describe --tags --always); \
		echo "Creating distribution package..."; \
		echo "Version: $$VERSION"; \
		mkdir -p webshot-$$VERSION; \
		cp example.yaml LICENSE Makefile README.md requirements.txt webshot.py webshot-$$VERSION/; \
		tar -cjf webshot-$$VERSION.tbz2 webshot-$$VERSION; \
		rm -rf webshot-$$VERSION; \
		echo "Distribution package created: webshot-$$VERSION.tbz2"; \
	else \
		echo "Error: There are uncommitted changes. Please commit all changes before creating a distribution package."; \
		exit 1; \
	fi
