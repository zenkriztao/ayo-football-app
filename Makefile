# AYO Football App - Makefile
# Convenient commands for building and running the app

.PHONY: help clean get build run-dev run-staging run-prod build-dev build-staging build-prod

help:
	@echo "AYO Football App - Available Commands:"
	@echo ""
	@echo "  make get           - Get dependencies"
	@echo "  make clean         - Clean build files"
	@echo ""
	@echo "Run Commands:"
	@echo "  make run-dev       - Run Development flavor"
	@echo "  make run-staging   - Run Staging flavor"
	@echo "  make run-prod      - Run Production flavor"
	@echo ""
	@echo "Build APK Commands:"
	@echo "  make build-dev     - Build Development APK"
	@echo "  make build-staging - Build Staging APK"
	@echo "  make build-prod    - Build Production APK"
	@echo ""
	@echo "Build iOS Commands:"
	@echo "  make ios-dev       - Build Development iOS"
	@echo "  make ios-staging   - Build Staging iOS"
	@echo "  make ios-prod      - Build Production iOS"

# Dependencies
get:
	fvm flutter pub get

clean:
	fvm flutter clean
	fvm flutter pub get

# Run commands
run-dev:
	fvm flutter run --flavor dev -t lib/main_dev.dart

run-staging:
	fvm flutter run --flavor staging -t lib/main_staging.dart

run-prod:
	fvm flutter run --flavor prod -t lib/main_prod.dart

# Build APK commands
build-dev:
	fvm flutter build apk --flavor dev -t lib/main_dev.dart

build-staging:
	fvm flutter build apk --flavor staging -t lib/main_staging.dart

build-prod:
	fvm flutter build apk --flavor prod -t lib/main_prod.dart --release

# Build iOS commands
ios-dev:
	fvm flutter build ios --flavor dev -t lib/main_dev.dart

ios-staging:
	fvm flutter build ios --flavor staging -t lib/main_staging.dart

ios-prod:
	fvm flutter build ios --flavor prod -t lib/main_prod.dart --release

# Build App Bundle (for Play Store)
bundle-prod:
	fvm flutter build appbundle --flavor prod -t lib/main_prod.dart --release

# Run tests
test:
	fvm flutter test

# Generate code (if using build_runner)
generate:
	fvm flutter pub run build_runner build --delete-conflicting-outputs

# Watch code generation
watch:
	fvm flutter pub run build_runner watch --delete-conflicting-outputs
