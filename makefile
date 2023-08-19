REPO = lambda-requests-s3
STAGE = dev
VENV_DIR = venv
LIB_REQUIREMENTS = $(VENV_DIR)/requirements/
GIT_HASH := $(shell git rev-parse --short HEAD)
PACKAGE_NAME = ${REPO}.zip
AUTO_APPROVE=$(if $(filter $(TF_ACTION),apply),--auto-approve,)
COLOR_FLAG=$(if $(filter $(COLOR),0),-no-color,)

.PHONY: package clean upload install venv

package: install
	@echo "Creating package..."
	@cd src && zip -r ../$(PACKAGE_NAME) ./*
	@cd $(LIB_REQUIREMENTS) && zip -ur ../../$(PACKAGE_NAME) ./*
	@echo "Package created: $(PACKAGE_NAME)"
	@rm -rf $(VENV_DIR)/requirements/	

install: venv
	@echo "Installing dependencies..."
	@$(VENV_DIR)/bin/pip install -r requirements.txt -t $(LIB_REQUIREMENTS)
	@echo "Dependencies installed."

venv:
	@if [ -d "$(VENV_DIR)" ]; then \
		echo "Virtual environment already exists at $(VENV_DIR)."; \
	else \
		echo "Creating virtual environment..."; \
		python3 -m venv $(VENV_DIR); \
		echo "Virtual environment created."; \
	fi

clean:
	@echo "Cleaning up..."
	@rm -f $(PACKAGE_NAME)
	@rm -rf $(VENV_DIR)/requirements/
	@echo "Cleanup complete."

tf_update_lambda: package
	@cd ./infrastructure/aws/${STAGE} && \
		terraform init && \
		terraform $(TF_ACTION) $(COLOR_FLAG) -var "tag=$(GIT_HASH)" $(AUTO_APPROVE)
