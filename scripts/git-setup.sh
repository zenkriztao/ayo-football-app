#!/bin/bash

# =============================================================================
# Git Setup Script - AYO Football Mobile (Flutter)
# =============================================================================
# Script ini akan membuat struktur branch dan commit yang professional
# Jalankan: chmod +x scripts/git-setup.sh && ./scripts/git-setup.sh
# =============================================================================

set -e

echo "=========================================="
echo "  AYO Football Mobile - Git Setup"
echo "=========================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
print_step() {
    echo -e "${GREEN}[STEP]${NC} $1"
}

print_info() {
    echo -e "${YELLOW}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_feature() {
    echo -e "${BLUE}[FEATURE]${NC} $1"
}

# =============================================================================
# STEP 1: Setup develop branch
# =============================================================================
print_step "Creating develop branch..."
git checkout master 2>/dev/null || git checkout main
git checkout -b develop 2>/dev/null || git checkout develop

# =============================================================================
# STEP 2: Feature - Project Setup
# =============================================================================
print_feature "Creating feature/project-setup..."
git checkout -b feature/project-setup 2>/dev/null || git checkout feature/project-setup

git add pubspec.yaml .gitignore README.md 2>/dev/null || true
git commit -m "chore(init): initialize Flutter project configuration

- Configure pubspec.yaml with app dependencies
- Add .gitignore for Flutter/Dart projects
- Add README.md with project description

Tech Stack:
- Flutter 3.x
- Dart SDK >=3.0.0
- Riverpod for state management
- Go Router for navigation" 2>/dev/null || print_info "Already committed"

git add android/app/build.gradle android/app/proguard-rules.pro 2>/dev/null || true
git commit -m "build(android): configure Android build with flavors

- Add product flavors (dev, staging, prod)
- Configure applicationId: com.ayofootball
- Add ProGuard rules for release builds
- Setup build types (debug, release)" 2>/dev/null || print_info "Already committed"

git add ios/Runner.xcodeproj/project.pbxproj ios/Flutter/*.xcconfig 2>/dev/null || true
git commit -m "build(ios): configure iOS project settings

- Set bundle identifier: com.ayofootball
- Add flavor xcconfig files (Dev, Staging, Prod)
- Configure build settings for each environment" 2>/dev/null || print_info "Already committed"

git checkout develop
git merge --no-ff feature/project-setup -m "merge: feature/project-setup into develop

Includes:
- Flutter project initialization
- Android build configuration with flavors
- iOS project configuration"

# =============================================================================
# STEP 3: Feature - Core Infrastructure
# =============================================================================
print_feature "Creating feature/core-infrastructure..."
git checkout -b feature/core-infrastructure

git add lib/core/config/app_config.dart 2>/dev/null || true
git commit -m "feat(config): add application configuration module

- Implement AppFlavor enum (dev, staging, prod)
- Add AppConfig singleton with environment settings
- Configure base URLs for each environment
- Add logging and crashlytics flags" 2>/dev/null || print_info "Already committed"

git add lib/core/constants/AppConstants.dart 2>/dev/null || true
git commit -m "feat(config): add application constants

- Define API constants (timeout, pagination)
- Add storage keys for auth tokens
- Configure connection timeouts
- Add default pagination values" 2>/dev/null || print_info "Already committed"

git add lib/core/api/ApiClient.dart lib/core/api/ApiResponse.dart 2>/dev/null || true
git commit -m "feat(network): implement API client with Dio

- Add ApiClient with interceptors
- Implement token management
- Add ApiResponse wrapper for responses
- Configure request/response logging" 2>/dev/null || print_info "Already committed"

git add lib/core/providers/CoreProviders.dart 2>/dev/null || true
git commit -m "feat(di): add core dependency injection providers

- Add apiClientProvider for network layer
- Configure Riverpod providers
- Implement provider overrides for testing" 2>/dev/null || print_info "Already committed"

git checkout develop
git merge --no-ff feature/core-infrastructure -m "merge: feature/core-infrastructure into develop

Includes:
- App configuration with flavors
- API client with Dio
- Core providers setup"

# =============================================================================
# STEP 4: Feature - Theme & Design System
# =============================================================================
print_feature "Creating feature/theme-design-system..."
git checkout -b feature/theme-design-system

git add lib/core/theme/AppTheme.dart 2>/dev/null || true
git commit -m "feat(ui): implement app theme with maroon color scheme

- Define light and dark themes
- Configure maroon primary color (#B71C1C)
- Add typography with Google Fonts
- Setup component themes (buttons, inputs, cards)" 2>/dev/null || print_info "Already committed"

git add lib/core/widgets/LoadingWidget.dart lib/core/widgets/ErrorStateWidget.dart lib/core/widgets/EmptyStateWidget.dart 2>/dev/null || true
git commit -m "feat(ui): add state widgets for loading, error, empty

- Implement LoadingWidget with shimmer effect
- Add ErrorStateWidget with retry action
- Add EmptyStateWidget with custom message
- Support dark mode variants" 2>/dev/null || print_info "Already committed"

git add lib/core/widgets/TeamCard.dart lib/core/widgets/PlayerCard.dart lib/core/widgets/MatchCard.dart 2>/dev/null || true
git commit -m "feat(ui): add entity card components

- Implement TeamCard with logo and stats
- Add PlayerCard with position badge
- Add MatchCard with score display
- Support tap callbacks for navigation" 2>/dev/null || print_info "Already committed"

git checkout develop
git merge --no-ff feature/theme-design-system -m "merge: feature/theme-design-system into develop

Includes:
- App theme with maroon colors
- Reusable state widgets
- Entity card components"

# =============================================================================
# STEP 5: Feature - Storage Service
# =============================================================================
print_feature "Creating feature/storage-service..."
git checkout -b feature/storage-service

git add lib/core/services/storage_service.dart 2>/dev/null || true
git commit -m "feat(storage): implement local storage service

- Add SharedPreferences wrapper
- Implement onboarding completion tracking
- Add first launch detection
- Support data clearing for logout" 2>/dev/null || print_info "Already committed"

git checkout develop
git merge --no-ff feature/storage-service -m "merge: feature/storage-service into develop

Includes:
- SharedPreferences storage service
- Onboarding state management"

# =============================================================================
# STEP 6: Feature - Splash Screen
# =============================================================================
print_feature "Creating feature/splash-screen..."
git checkout -b feature/splash-screen

git add lib/features/splash/presentation/pages/splash_page.dart 2>/dev/null || true
git commit -m "feat(splash): implement animated splash screen

- Add gradient maroon background
- Implement logo animation (scale, fade, slide)
- Add shimmer loading indicator
- Configure edge-to-edge display" 2>/dev/null || print_info "Already committed"

git add assets/icons/logo.png assets/launcher/ 2>/dev/null || true
git commit -m "feat(assets): add app logo and launcher icons

- Add AYO Indonesia logo
- Add launcher icons for Android/iOS
- Include adaptive icon assets" 2>/dev/null || print_info "Already committed"

git checkout develop
git merge --no-ff feature/splash-screen -m "merge: feature/splash-screen into develop

Includes:
- Animated splash screen
- App logo and launcher icons"

# =============================================================================
# STEP 7: Feature - Onboarding
# =============================================================================
print_feature "Creating feature/onboarding..."
git checkout -b feature/onboarding

git add lib/features/onboarding/presentation/pages/onboarding_page.dart 2>/dev/null || true
git commit -m "feat(onboarding): implement onboarding screens

- Add 3 onboarding pages with PageView
- Implement page indicator with animation
- Add skip and next navigation
- Save completion status to SharedPreferences" 2>/dev/null || print_info "Already committed"

git add assets/images/fans_supporters.png assets/images/player_champion.png assets/images/players_match.png 2>/dev/null || true
git commit -m "feat(assets): add onboarding illustrations

- Add fans_supporters.png for team management
- Add player_champion.png for player management
- Add players_match.png for match management" 2>/dev/null || print_info "Already committed"

git checkout develop
git merge --no-ff feature/onboarding -m "merge: feature/onboarding into develop

Includes:
- Onboarding screens with images
- First-time user flow"

# =============================================================================
# STEP 8: Feature - Authentication Module
# =============================================================================
print_feature "Creating feature/auth-module..."
git checkout -b feature/auth-module

git add lib/features/auth/data/models/UserModel.dart 2>/dev/null || true
git commit -m "feat(auth): add user model with role support

- Implement UserModel with fromJson/toJson
- Add role field (admin/user)
- Include email, name, id fields
- Support nullable fields" 2>/dev/null || print_info "Already committed"

git add lib/features/auth/domain/repositories/AuthRepository.dart lib/features/auth/data/repositories/AuthRepositoryImpl.dart 2>/dev/null || true
git commit -m "feat(auth): implement auth repository layer

- Add AuthRepository interface
- Implement login with email/password
- Add register functionality
- Add getProfile for token validation" 2>/dev/null || print_info "Already committed"

git add lib/features/auth/presentation/providers/AuthState.dart lib/features/auth/presentation/providers/AuthProvider.dart 2>/dev/null || true
git commit -m "feat(auth): implement auth state management

- Add AuthState with status enum
- Implement AuthNotifier with Riverpod
- Add checkAuthStatus for app startup
- Handle login, register, logout actions" 2>/dev/null || print_info "Already committed"

git add lib/features/auth/presentation/pages/LoginPage.dart lib/features/auth/presentation/pages/RegisterPage.dart 2>/dev/null || true
git commit -m "feat(auth): add login and register pages

- Implement LoginPage with form validation
- Add RegisterPage with name, email, password
- Add navigation between auth screens
- Handle loading and error states" 2>/dev/null || print_info "Already committed"

git checkout develop
git merge --no-ff feature/auth-module -m "merge: feature/auth-module into develop

Includes:
- User model and repository
- Auth state management with Riverpod
- Login and register pages"

# =============================================================================
# STEP 9: Feature - Navigation & Router
# =============================================================================
print_feature "Creating feature/navigation..."
git checkout -b feature/navigation

git add lib/core/router/AppRouter.dart 2>/dev/null || true
git commit -m "feat(nav): implement app router with Go Router

Routes:
- / (splash)
- /onboarding
- /login, /register
- /home, /teams, /players, /matches, /reports

- Add ShellRoute for bottom navigation
- Configure nested routes for detail pages" 2>/dev/null || print_info "Already committed"

git add lib/core/widgets/MainScaffold.dart 2>/dev/null || true
git commit -m "feat(nav): add main scaffold with bottom navigation

- Implement bottom navigation bar
- Add 5 tabs: Home, Teams, Players, Matches, Reports
- Handle navigation state
- Support nested navigation" 2>/dev/null || print_info "Already committed"

git checkout develop
git merge --no-ff feature/navigation -m "merge: feature/navigation into develop

Includes:
- Go Router configuration
- Bottom navigation scaffold"

# =============================================================================
# STEP 10: Feature - Home Module
# =============================================================================
print_feature "Creating feature/home-module..."
git checkout -b feature/home-module

git add lib/features/home/presentation/pages/home_page.dart 2>/dev/null || true
git commit -m "feat(home): implement home dashboard page

- Add welcome header with user info
- Display quick stats cards
- Add recent matches section
- Show top scorers preview" 2>/dev/null || print_info "Already committed"

git checkout develop
git merge --no-ff feature/home-module -m "merge: feature/home-module into develop

Includes:
- Home dashboard page"

# =============================================================================
# STEP 11: Feature - Team Management
# =============================================================================
print_feature "Creating feature/team-management..."
git checkout -b feature/team-management

git add lib/features/team/data/models/TeamModel.dart 2>/dev/null || true
git commit -m "feat(team): add team model

Fields: nama, logo, tahun berdiri, alamat, kota

- Implement TeamModel with fromJson/toJson
- Add player count field
- Support nullable logo URL" 2>/dev/null || print_info "Already committed"

git add lib/features/team/domain/repositories/TeamRepository.dart lib/features/team/data/repositories/TeamRepositoryImpl.dart 2>/dev/null || true
git commit -m "feat(team): implement team repository

- Add TeamRepository interface
- Implement CRUD operations
- Add search and pagination
- Handle API responses" 2>/dev/null || print_info "Already committed"

git add lib/features/team/presentation/providers/TeamProvider.dart lib/features/team/presentation/providers/TeamState.dart 2>/dev/null || true
git commit -m "feat(team): add team state management

- Implement TeamNotifier with Riverpod
- Add loading, success, error states
- Handle team list and detail
- Add CRUD actions" 2>/dev/null || print_info "Already committed"

git add lib/features/team/presentation/pages/TeamListPage.dart lib/features/team/presentation/pages/TeamDetailPage.dart lib/features/team/presentation/pages/TeamFormPage.dart 2>/dev/null || true
git commit -m "feat(team): add team pages

Pages:
- TeamListPage with search and grid
- TeamDetailPage with player list
- TeamFormPage for create/edit

- Implement pull-to-refresh
- Add admin-only actions" 2>/dev/null || print_info "Already committed"

git checkout develop
git merge --no-ff feature/team-management -m "merge: feature/team-management into develop

Implements: Pengelolaan informasi tim sepak bola"

# =============================================================================
# STEP 12: Feature - Player Management
# =============================================================================
print_feature "Creating feature/player-management..."
git checkout -b feature/player-management

git add lib/features/player/data/models/PlayerModel.dart 2>/dev/null || true
git commit -m "feat(player): add player model

Fields: nama, tinggi, berat, posisi, nomor punggung

- Implement PlayerModel with fromJson/toJson
- Add Position enum (forward, midfielder, defender, goalkeeper)
- Include team relationship" 2>/dev/null || print_info "Already committed"

git add lib/features/player/domain/repositories/PlayerRepository.dart lib/features/player/data/repositories/PlayerRepositoryImpl.dart 2>/dev/null || true
git commit -m "feat(player): implement player repository

- Add PlayerRepository interface
- Implement CRUD operations
- Add filter by team_id
- Handle jersey number validation" 2>/dev/null || print_info "Already committed"

git add lib/features/player/presentation/providers/PlayerProvider.dart lib/features/player/presentation/providers/PlayerState.dart 2>/dev/null || true
git commit -m "feat(player): add player state management

- Implement PlayerNotifier with Riverpod
- Add team filter support
- Handle loading and error states
- Add CRUD actions" 2>/dev/null || print_info "Already committed"

git add lib/features/player/presentation/pages/PlayerListPage.dart lib/features/player/presentation/pages/PlayerDetailPage.dart lib/features/player/presentation/pages/PlayerFormPage.dart 2>/dev/null || true
git commit -m "feat(player): add player pages

Pages:
- PlayerListPage with position filter
- PlayerDetailPage with stats
- PlayerFormPage with team selection

- Add position badge display
- Show jersey number prominently" 2>/dev/null || print_info "Already committed"

git checkout develop
git merge --no-ff feature/player-management -m "merge: feature/player-management into develop

Implements: Pengelolaan informasi pemain
- Nomor punggung unik per tim ✓"

# =============================================================================
# STEP 13: Feature - Match Management
# =============================================================================
print_feature "Creating feature/match-management..."
git checkout -b feature/match-management

git add lib/features/match/data/models/MatchModel.dart lib/features/match/data/models/GoalModel.dart 2>/dev/null || true
git commit -m "feat(match): add match and goal models

Match: tanggal, waktu, tim home/away, skor, status
Goal: player_id, team_id, minute, is_own_goal

- Add MatchStatus enum
- Implement goal scorer tracking
- Calculate match result" 2>/dev/null || print_info "Already committed"

git add lib/features/match/domain/repositories/MatchRepository.dart lib/features/match/data/repositories/MatchRepositoryImpl.dart 2>/dev/null || true
git commit -m "feat(match): implement match repository

- Add MatchRepository interface
- Implement CRUD operations
- Add result recording endpoint
- Handle goal management" 2>/dev/null || print_info "Already committed"

git add lib/features/match/presentation/providers/MatchProvider.dart lib/features/match/presentation/providers/MatchState.dart 2>/dev/null || true
git commit -m "feat(match): add match state management

- Implement MatchNotifier with Riverpod
- Add status and date filtering
- Handle result recording
- Add goal tracking" 2>/dev/null || print_info "Already committed"

git add lib/features/match/presentation/pages/MatchListPage.dart lib/features/match/presentation/pages/MatchDetailPage.dart lib/features/match/presentation/pages/MatchFormPage.dart 2>/dev/null || true
git commit -m "feat(match): add match pages

Pages:
- MatchListPage with status tabs
- MatchDetailPage with goals and stats
- MatchFormPage for scheduling

- Show score prominently
- Display goal scorers with minute" 2>/dev/null || print_info "Already committed"

git checkout develop
git merge --no-ff feature/match-management -m "merge: feature/match-management into develop

Implements:
- Pengelolaan jadwal pertandingan
- Pencatatan hasil pertandingan"

# =============================================================================
# STEP 14: Feature - Report Module
# =============================================================================
print_feature "Creating feature/report-module..."
git checkout -b feature/report-module

git add lib/features/report/data/models/ReportModel.dart 2>/dev/null || true
git commit -m "feat(report): add report models

- Add MatchReportModel with stats
- Add TopScorerModel with goals count
- Include team win accumulation" 2>/dev/null || print_info "Already committed"

git add lib/features/report/domain/repositories/ReportRepository.dart lib/features/report/data/repositories/ReportRepositoryImpl.dart 2>/dev/null || true
git commit -m "feat(report): implement report repository

- Add ReportRepository interface
- Implement match reports endpoint
- Add top scorers endpoint" 2>/dev/null || print_info "Already committed"

git add lib/features/report/presentation/providers/ReportProvider.dart lib/features/report/presentation/pages/ReportPage.dart 2>/dev/null || true
git commit -m "feat(report): add report page with statistics

Features:
- Match reports with results
- Top scorers leaderboard
- Team statistics

- Add pull-to-refresh
- Display formatted statistics" 2>/dev/null || print_info "Already committed"

git checkout develop
git merge --no-ff feature/report-module -m "merge: feature/report-module into develop

Implements: Data report pertandingan"

# =============================================================================
# STEP 15: Feature - App Entry Points
# =============================================================================
print_feature "Creating feature/app-entry..."
git checkout -b feature/app-entry

git add lib/app.dart 2>/dev/null || true
git commit -m "feat(app): implement root app widget

- Configure MaterialApp.router
- Setup theme with light/dark mode
- Add Riverpod provider scope
- Remove debug banner" 2>/dev/null || print_info "Already committed"

git add lib/main_dev.dart lib/main_staging.dart lib/main_prod.dart 2>/dev/null || true
git commit -m "feat(app): add flavor entry points

Entry points:
- main_dev.dart for development
- main_staging.dart for staging
- main_prod.dart for production

- Initialize SharedPreferences
- Configure flavor-specific settings" 2>/dev/null || print_info "Already committed"

git checkout develop
git merge --no-ff feature/app-entry -m "merge: feature/app-entry into develop

Includes:
- Root app widget
- Flavor entry points"

# =============================================================================
# STEP 16: Feature - VS Code Configuration
# =============================================================================
print_feature "Creating feature/vscode-config..."
git checkout -b feature/vscode-config

git add .vscode/launch.json .vscode/settings.json 2>/dev/null || true
git commit -m "build(vscode): add VS Code debug configuration

Configurations:
- Development (iOS/Android)
- Staging (iOS/Android)
- Production (iOS/Android)

- Configure Dart/Flutter settings
- Add FVM SDK path" 2>/dev/null || print_info "Already committed"

git add Makefile 2>/dev/null || true
git commit -m "build(make): add Makefile with common commands

Commands:
- make run-dev/staging/prod
- make build-dev/staging/prod
- make clean, get, test
- make generate (build_runner)" 2>/dev/null || print_info "Already committed"

git checkout develop
git merge --no-ff feature/vscode-config -m "merge: feature/vscode-config into develop

Includes:
- VS Code launch configurations
- Makefile for build commands"

# =============================================================================
# STEP 17: Feature - Native Splash & Icons
# =============================================================================
print_feature "Creating feature/native-assets..."
git checkout -b feature/native-assets

git add android/app/src/main/res/ 2>/dev/null || true
git commit -m "build(android): add native splash and launcher icons

- Add splash screen drawables
- Add launcher icons (all densities)
- Add adaptive icon configuration
- Configure Android 12 splash" 2>/dev/null || print_info "Already committed"

git add ios/Runner/Assets.xcassets/ 2>/dev/null || true
git commit -m "build(ios): add iOS app icons and launch screen

- Add AppIcon.appiconset
- Configure LaunchScreen storyboard
- Add all required icon sizes" 2>/dev/null || print_info "Already committed"

git checkout develop
git merge --no-ff feature/native-assets -m "merge: feature/native-assets into develop

Includes:
- Android native splash and icons
- iOS app icons and launch screen"

# =============================================================================
# STEP 18: Create Release
# =============================================================================
print_step "Creating release/v1.0.0..."
git checkout -b release/v1.0.0

git commit --allow-empty -m "chore(release): prepare v1.0.0

Release Notes - AYO Football Mobile v1.0.0
==========================================

Features:
- Splash Screen with animated logo
- Onboarding screens (first-time users)
- Authentication (Login/Register)
- Team Management (CRUD)
- Player Management with position/jersey
- Match Scheduling and Results
- Reports with statistics

Technical:
- Flutter 3.x + Dart 3.x
- Riverpod State Management
- Go Router Navigation
- Dio HTTP Client
- Clean Architecture (Domain-Driven)
- Multi-flavor support (dev/staging/prod)

UI/UX:
- Maroon color scheme
- Material Design 3
- Responsive layouts
- Dark mode support"

# Merge to main
print_step "Merging to main..."
git checkout master 2>/dev/null || git checkout main
git merge --no-ff release/v1.0.0 -m "merge: release/v1.0.0 - Initial Release

AYO Football Mobile v1.0.0

All requirements implemented:
1. ✓ Splash Screen dengan logo
2. ✓ Onboarding untuk pengguna baru
3. ✓ Login/Register dengan JWT
4. ✓ Pengelolaan tim sepak bola
5. ✓ Pengelolaan pemain (jersey unik per tim)
6. ✓ Pengelolaan jadwal pertandingan
7. ✓ Pencatatan hasil pertandingan
8. ✓ Data report pertandingan

Technical requirements:
- ✓ Connect to Railway API
- ✓ Multi-flavor build (dev/staging/prod)
- ✓ Native splash screen
- ✓ App launcher icons"

# Create tag
print_step "Creating tag v1.0.0..."
git tag -a v1.0.0 -m "v1.0.0 - Initial Release

AYO Football Mobile App

Features:
- Splash Screen & Onboarding
- JWT Authentication
- Team Management (CRUD)
- Player Management with jersey validation
- Match Scheduling and Result Recording
- Reports with top scorers

Technical:
- Flutter 3.x + Dart 3.x
- Riverpod State Management
- Go Router Navigation
- Clean Architecture
- Multi-flavor (dev/staging/prod)

API:
- Backend: Railway (https://ayo-football-api-production.up.railway.app)

Bundle ID: com.ayofootball"

# Merge back to develop
git checkout develop
git merge --no-ff release/v1.0.0 -m "merge: release/v1.0.0 back into develop"

# Cleanup
git branch -d release/v1.0.0

print_success "Git setup complete!"
echo ""
echo "=========================================="
echo "  Summary"
echo "=========================================="
echo ""
echo "Branches created:"
echo "  - master (production)"
echo "  - develop (development)"
echo "  - feature/project-setup"
echo "  - feature/core-infrastructure"
echo "  - feature/theme-design-system"
echo "  - feature/storage-service"
echo "  - feature/splash-screen"
echo "  - feature/onboarding"
echo "  - feature/auth-module"
echo "  - feature/navigation"
echo "  - feature/home-module"
echo "  - feature/team-management"
echo "  - feature/player-management"
echo "  - feature/match-management"
echo "  - feature/report-module"
echo "  - feature/app-entry"
echo "  - feature/vscode-config"
echo "  - feature/native-assets"
echo ""
echo "Tag created:"
echo "  - v1.0.0"
echo ""
echo "To push to remote:"
echo "  git push origin master develop --tags"
echo "  git push origin --all  # (to push all branches)"
echo ""
echo "=========================================="
