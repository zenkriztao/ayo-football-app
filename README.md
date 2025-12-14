<img width="611" height="269" alt="logo" src="https://github.com/user-attachments/assets/4a273f47-dc08-4626-a89a-d4bbc640a8cb" />

# AYO Football App

A Flutter mobile application for managing football teams, players, and matches. This app integrates with the AYO Football Backend API hosted on Railway.

## Live API

```
Base URL: https://ayo-football-api-production.up.railway.app/api/v1
```

## Record 



## Screen

| Screen 1                                                                                                  | Screen 2                                                                                                  | Screen 3                                                                                                  |
| --------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| <img src="https://github.com/user-attachments/assets/a5b37a3c-16de-4f18-8a69-98c7b01499b0" width="250" /> | <img src="https://github.com/user-attachments/assets/13d5ebdb-4319-4873-8ff8-9f58e1a89da0" width="250" /> | <img src="https://github.com/user-attachments/assets/8855aca1-8324-4a5f-9556-ea3eac5327a5" width="250" /> |
| <img src="https://github.com/user-attachments/assets/4541868a-3329-4294-8c6d-a68c0d5d08a0" width="250" /> | <img src="https://github.com/user-attachments/assets/81076d5c-a2ce-40c5-9696-c7de798fadd4" width="250" /> | <img src="https://github.com/user-attachments/assets/f9e12454-063a-4af8-a365-d5777529591f" width="250" /> |
| <img src="https://github.com/user-attachments/assets/1de24b00-a100-47a9-95c7-34b4544c02da" width="250" /> | <img src="https://github.com/user-attachments/assets/21679fde-c8d1-4c78-b554-3fd1049f6ba2" width="250" /> | <img src="https://github.com/user-attachments/assets/2400adef-41c3-48be-8ac7-70e019f5b794" width="250" /> |
| <img src="https://github.com/user-attachments/assets/081f420c-67e4-48d1-b3ad-98fbbecf4987" width="250" /> | <img src="https://github.com/user-attachments/assets/65d9a070-b25d-4cfd-ac45-53c3af41c000" width="250" /> | <img src="https://github.com/user-attachments/assets/c2a1311a-0ac2-4e40-9a0d-f15956c92353" width="250" /> |
| <img src="https://github.com/user-attachments/assets/99107852-cebe-4964-9da8-8dacd4751358" width="250" /> | <img src="https://github.com/user-attachments/assets/bfc90aaf-131a-45a2-bd0e-9fb1c361c50c" width="250" /> | <img src="https://github.com/user-attachments/assets/86b4f01d-cfb8-44cf-a234-76159b45d7df" width="250" /> |
| <img src="https://github.com/user-attachments/assets/40adb860-2d6e-4d2e-ba15-b7693aafcc5a" width="250" /> | <img src="https://github.com/user-attachments/assets/84180182-4667-4b5f-b01c-6207b6036bf3" width="250" /> | <img src="https://github.com/user-attachments/assets/91dd99d2-6992-4be2-8308-ef42168d6965" width="250" /> |
| <img src="https://github.com/user-attachments/assets/6411f553-b578-431e-92f1-f10831f17d81" width="250" /> | —                                                                                                         | —                                                                                                         |
<img width="1504" height="781" alt="Screenshot 2025-12-14 at 12 46 52" src="https://github.com/user-attachments/assets/b35fe22a-b2c4-4785-a360-4403a0c9969f" />


## QA Testing Status

| Feature | Status |
|---------|--------|
| Splash Screen | Tested |
| Onboarding | Tested |
| Authentication (Login/Register) | Tested |
| Home Dashboard | Tested |
| Team Management | Tested |
| Player Management | Tested |
| Match Management | Tested |
| Reports | Tested |

## Features

- **Splash Screen**: Animated logo with maroon gradient theme
- **Onboarding**: 3-page introduction with custom illustrations
- **Authentication**: Login/Register with JWT-based authentication
- **Team Management**: Create, view, edit, and delete football teams
- **Player Management**: Manage players with position and jersey number
- **Match Management**: Schedule matches and record results
- **Reports**: View match reports and statistics

## Technology Stack

| Category | Technology |
|----------|------------|
| Framework | Flutter 3.0+ |
| State Management | Riverpod |
| HTTP Client | Dio |
| Navigation | go_router |
| Local Storage | SharedPreferences, flutter_secure_storage |
| Architecture | Clean Architecture (Feature-First) |
| UI Components | Material Design 3 |

## Project Structure

```
lib/
├── main_dev.dart          # Development entry point
├── main_staging.dart      # Staging entry point
├── main_prod.dart         # Production entry point
├── app.dart               # Root app widget
├── core/
│   ├── api/
│   │   ├── ApiClient.dart
│   │   └── ApiResponse.dart
│   ├── config/
│   │   └── app_config.dart
│   ├── constants/
│   │   └── AppConstants.dart
│   ├── providers/
│   │   └── CoreProviders.dart
│   ├── router/
│   │   └── AppRouter.dart
│   ├── services/
│   │   └── storage_service.dart
│   ├── theme/
│   │   └── AppTheme.dart
│   └── widgets/
│       ├── MainScaffold.dart
│       ├── LoadingWidget.dart
│       ├── ErrorStateWidget.dart
│       ├── EmptyStateWidget.dart
│       ├── TeamCard.dart
│       ├── PlayerCard.dart
│       ├── MatchCard.dart
│       └── ...
└── features/
    ├── splash/
    │   └── presentation/pages/splash_page.dart
    ├── onboarding/
    │   └── presentation/pages/onboarding_page.dart
    ├── auth/
    │   ├── data/
    │   │   ├── models/UserModel.dart
    │   │   └── repositories/AuthRepositoryImpl.dart
    │   ├── domain/
    │   │   └── repositories/AuthRepository.dart
    │   └── presentation/
    │       ├── providers/AuthProvider.dart
    │       └── pages/
    │           ├── LoginPage.dart
    │           └── RegisterPage.dart
    ├── home/
    │   └── presentation/pages/home_page.dart
    ├── team/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    │       └── pages/
    │           ├── TeamListPage.dart
    │           ├── TeamDetailPage.dart
    │           └── TeamFormPage.dart
    ├── player/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    │       └── pages/
    │           ├── PlayerListPage.dart
    │           ├── PlayerDetailPage.dart
    │           └── PlayerFormPage.dart
    ├── match/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    │       └── pages/
    │           ├── MatchListPage.dart
    │           ├── MatchDetailPage.dart
    │           └── MatchFormPage.dart
    └── report/
        └── presentation/pages/ReportPage.dart
```

## Getting Started

### Prerequisites

- Flutter SDK 3.0 or higher
- Dart SDK 3.0 or higher
- Android Studio / VS Code
- FVM (Flutter Version Management) - Optional

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/zenkriztao/ayo-football-app.git
   cd ayo-football-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**

   Using Make commands:
   ```bash
   # Development
   make run-dev

   # Staging
   make run-staging

   # Production
   make run-prod
   ```

   Or using Flutter directly:
   ```bash
   # Development
   flutter run -t lib/main_dev.dart --flavor dev

   # Staging
   flutter run -t lib/main_staging.dart --flavor staging

   # Production
   flutter run -t lib/main_prod.dart --flavor prod
   ```

### VS Code Debug Configuration

Press `Cmd+Shift+D` (macOS) or `Ctrl+Shift+D` (Windows/Linux) to open debug panel and select:

- **Development (iOS)** - Run dev flavor on iOS
- **Development (Android)** - Run dev flavor on Android
- **Staging (iOS)** - Run staging flavor on iOS
- **Staging (Android)** - Run staging flavor on Android
- **Production (iOS)** - Run production flavor on iOS
- **Production (Android)** - Run production flavor on Android

## Build Flavors

| Flavor | Package ID | Description |
|--------|------------|-------------|
| dev | com.ayofootball.dev | Development with logging enabled |
| staging | com.ayofootball.staging | Staging for QA testing |
| prod | com.ayofootball | Production release |

### Building for Release

```bash
# Android APK (Development)
flutter build apk -t lib/main_dev.dart --flavor dev

# Android APK (Production)
flutter build apk -t lib/main_prod.dart --flavor prod --release

# Android App Bundle (Production)
flutter build appbundle -t lib/main_prod.dart --flavor prod --release

# iOS (Production)
flutter build ios -t lib/main_prod.dart --release
```

## API Configuration

The app connects to the AYO Football Backend API hosted on Railway:

| Environment | Base URL |
|-------------|----------|
| Development | https://ayo-football-api-production.up.railway.app/api/v1 |
| Staging | https://ayo-football-api-production.up.railway.app/api/v1 |
| Production | https://ayo-football-api-production.up.railway.app/api/v1 |

### API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /auth/login | User login |
| POST | /auth/register | User registration |
| GET | /teams | List all teams |
| POST | /teams | Create team |
| GET | /teams/:id | Get team detail |
| PUT | /teams/:id | Update team |
| DELETE | /teams/:id | Delete team |
| GET | /players | List all players |
| POST | /players | Create player |
| GET | /players/:id | Get player detail |
| PUT | /players/:id | Update player |
| DELETE | /players/:id | Delete player |
| GET | /matches | List all matches |
| POST | /matches | Create match |
| GET | /matches/:id | Get match detail |
| PUT | /matches/:id | Update match |
| DELETE | /matches/:id | Delete match |
| GET | /reports/matches | Match reports |

## Default Admin Credentials

```
Email: admin@ayofootball.com
Password: Admin@123
```

## App Flow

```
Splash Screen
     │
     ▼
┌─────────────────┐
│ First Launch?   │
└────────┬────────┘
         │
    ┌────┴────┐
    │ Yes     │ No
    ▼         ▼
Onboarding   Check Auth
    │             │
    ▼         ┌───┴───┐
  Login      │Logged │
    │        │  In?  │
    │        └───┬───┘
    │       Yes  │  No
    │        ▼   ▼
    └──────► Home ◄── Login
```

## Architecture

The app follows Clean Architecture principles with Riverpod for state management:

### Layers

1. **Presentation Layer**
   - Pages (UI)
   - Providers (State Management with Riverpod)
   - Widgets (Reusable UI Components)

2. **Domain Layer**
   - Entities (Business Objects)
   - Repositories (Abstract Interfaces)

3. **Data Layer**
   - Models (Data Transfer Objects)
   - Repository Implementations
   - API Client

## Git Branches

| Branch | Description |
|--------|-------------|
| master | Production-ready code |
| develop | Development branch |
| feature/* | Feature branches |
| release/* | Release preparation |

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Commit Convention

```
feat: add new feature
fix: bug fix
docs: documentation changes
style: formatting, missing semicolons, etc
refactor: code refactoring
test: adding tests
chore: maintenance tasks
```

## License

This project is licensed under the MIT License.

## Related Projects

- [AYO Football Backend](https://github.com/zenkriztao/ayo-football-backend) - The backend API (Go + Fiber)

## Contact

- GitHub: [@zenkriztao](https://github.com/zenkriztao)
