REPO = lambda-requests-s3
VENV_DIR = .venv
POETRY := $(VENV_DIR)/bin/poetry
GIT_HASH := $(shell git rev-parse --short HEAD)
ZIP_PACKAGE_NAME = ${REPO}.zip
ZIP_REQUIREMENTS_NAME = ${REPO}-requirements.zip
PATH_REQUIREMENTS = req

.PHONY: package clean tf_update_lambda venv install-poetry install-runtime-deps install-dev-deps install-all-deps


help:
	@echo "Available targets:"
	@echo "  venv         Create a virtual environment if not exists"
	@echo "  install-poetry      Install Poetry in the virtual environment"
	@echo "  install-runtime-deps     Install runtime dependencies"
	@echo "  install-dev-deps         Install development dependencies"
	@echo "  install-all-deps         Install both runtime and development dependencies"
	@echo "  package             Create a deployment package"
	@echo "  clean               Clean up generated files"
	@echo "  tf_update_lambda    Update Lambda using Terraform"

venv:
	@if [ -d $(VENV_DIR) ]; then \
		echo "Virtual environment '$(VENV_DIR)' already exists. Activate it using 'source $(VENV_DIR)/bin/activate'."; \
	else \
		echo "Creating virtual environment '$(VENV_DIR)'..."; \
		python3 -m venv $(VENV_DIR); \
		echo "Activating virtual environment..."; \
		. $(VENV_DIR)/bin/activate; \
		echo "Installing Poetry..."; \
		pip install poetry; \
	fi

install-poetry: venv
	@echo "Installing Poetry in the virtual environment..."
	@. $(VENV_DIR)/bin/activate && pip install poetry

install-runtime-deps: venv
	@echo "Installing runtime dependencies using Poetry..."
	@$(POETRY) install --no-dev --no-interaction --no-ansi --no-root

install-dev-deps: 
	@echo "Installing development dependencies using Poetry..."
	@$(POETRY) install --no-interaction --no-ansi --no-root

install-all-deps: 
	@echo "Installing all dependencies using Poetry..."
	@$(POETRY) install --no-interaction --no-ansi --no-root

package: install-runtime-deps
	@echo "Creating package..."
	@cd src/app && zip -r ${ZIP_PACKAGE_NAME} ./*
	@mv src/app/${ZIP_PACKAGE_NAME} .
	@echo "Package created: $(ZIP_PACKAGE_NAME)"
	@$(POETRY) export --without-hashes --format=requirements.txt > requirements.txt
	@pip install -r requirements.txt -t $(PATH_REQUIREMENTS)/python
	@cd $(PATH_REQUIREMENTS) && zip -r ${ZIP_REQUIREMENTS_NAME} ./*
	@mv $(PATH_REQUIREMENTS)/$(ZIP_REQUIREMENTS_NAME) .
	@echo "Package created: $(ZIP_REQUIREMENTS_NAME)"

clean:
	@echo "Cleaning up..."
	@rm -f $(ZIP_REQUIREMENTS_NAME)
	@rm -rf $(PATH_REQUIREMENTS)
	@rm -f $(ZIP_PACKAGE_NAME)
	@echo "Cleanup complete."

lint:
	@$(POETRY) run black src
	@$(POETRY) run flake8 src

isort:
	@$(POETRY) run isort src

test:
	@$(POETRY) run pytest src