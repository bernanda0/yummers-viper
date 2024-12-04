# Include and export all variables from .env
ifneq (,$(wildcard .env))
    include .env
    export
endif

# Colors for terminal output
BLUE := \033[0;34m
GREEN := \033[0;32m
RED := \033[0;31m
YELLOW := \033[0;33m
NC := \033[0m # No Color

# Default target
.PHONY: all
all: env generate

# Check and source .env file
.PHONY: env
env:
	@if [ -f .env ]; then \
		echo "$(BLUE)Loading environment variables...$(NC)"; \
		set -a; \
		. ./.env; \
		set +a; \
		echo "$(GREEN)✓ Environment variables loaded successfully$(NC)"; \
		echo "Bundle ID: $$TUIST_BUNDLE_ID"; \
	else \
		echo "$(RED)Error: .env file not found$(NC)"; \
		echo "$(YELLOW)Creating default .env file...$(NC)"; \
		echo "TUIST_BUNDLE_ID=com.bernanda" > .env; \
		echo "$(GREEN)✓ Created default .env file$(NC)"; \
	fi

# Generate Tuist project
.PHONY: generate
generate:
	@echo "$(BLUE)Generating Tuist project...$(NC)"
	@tuist generate
	@echo "$(GREEN)✓ Project generated successfully$(NC)"

# Clean Tuist project
.PHONY: clean
clean:
	@echo "$(BLUE)Cleaning Tuist project...$(NC)"
	@tuist clean
	@echo "$(GREEN)✓ Project cleaned successfully$(NC)"

# Install Tuist dependencies
.PHONY: install
install:
	@echo "$(BLUE)Installing Tuist dependencies...$(NC)"
	@tuist install
	@echo "$(GREEN)✓ Dependencies fetched successfully$(NC)"

# Edit Tuist project
.PHONY: edit
edit:
	@echo "$(BLUE)Opening Tuist project in Xcode...$(NC)"
	@tuist edit

# Build the app
.PHONY: build
build:
	@echo "$(BLUE)Building the app...$(NC)"
	@xcodebuild -scheme yummers -destination 'platform=iOS Simulator' build | xcpretty
	@echo "$(GREEN)✓ App built successfully$(NC)"

# Run unit tests
.PHONY: test
test:
	@echo "$(BLUE)Running unit tests...$(NC)"
	@xcodebuild -scheme yummersTests -destination 'platform=iOS Simulator' test | xcpretty
	@echo "$(GREEN)✓ Unit tests completed successfully$(NC)"

# Show help
.PHONY: help
help:
	@echo "$(BLUE)Available commands:$(NC)"
	@echo "  make           - Load environment, generate project, build and run tests"
	@echo "  make env       - Load environment variables"
	@echo "  make generate  - Generate Xcode project"
	@echo "  make build     - Build the app"
	@echo "  make test      - Run unit tests"
	@echo "  make clean     - Clean generated files"
	@echo "  make install     - Fetch dependencies"
	@echo "  make edit      - Open project in Xcode"
	@echo "  make help      - Show this help message"
