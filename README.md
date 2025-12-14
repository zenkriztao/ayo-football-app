# AYO Football App

A Flutter mobile application for managing football teams, players, and matches. This app integrates with the AYO Football Backend API.

## Features

- **Authentication**: Login/Register with JWT-based authentication
- **Team Management**: View and manage football teams
- **Player Management**: View and manage players with position and jersey number
- **Match Management**: View and manage match schedules and results
- **Reports**: View match reports and statistics

## Technology Stack

- **Framework**: Flutter 3.0+
- **State Management**: flutter_bloc (Cubit pattern)
- **Dependency Injection**: get_it
- **HTTP Client**: Dio
- **Navigation**: go_router
- **Local Storage**: flutter_secure_storage
- **Architecture**: Clean Architecture with Feature-First structure

## Project Structure

```
lib/
├── main.dart
├── core/
│   ├── api/
│   │   ├── api_client.dart
│   │   └── api_response.dart
│   ├── constants/
│   │   └── app_constants.dart
│   ├── di/
│   │   └── injection.dart
│   ├── router/
│   │   └── app_router.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── widgets/
│       └── main_scaffold.dart
└── features/
    ├── auth/
    │   ├── data/
    │   │   ├── models/
    │   │   └── repositories/
    │   ├── domain/
    │   │   └── repositories/
    │   └── presentation/
    │       ├── cubit/
    │       └── pages/
    ├── team/
    ├── player/
    ├── match/
    └── report/
```

## Getting Started

### Prerequisites

- Flutter SDK 3.0 or higher
- Dart SDK 3.0 or higher
- Android Studio / VS Code
- Backend API running (see ayo-football-backend)

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

3. **Configure API URL**

   Edit `lib/core/constants/app_constants.dart`:
   ```dart
   // For Android emulator
   static const String baseUrl = 'http://10.0.2.2:8080/api/v1';

   // For iOS simulator
   static const String baseUrl = 'http://localhost:8080/api/v1';

   // For physical device (use your computer's IP)
   static const String baseUrl = 'http://192.168.x.x:8080/api/v1';
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Building for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

## Default Admin Credentials

```
Email: admin@ayofootball.com
Password: Admin@123
```

## Screenshots

The app features:
- Team list with search functionality
- Player list with filtering by team
- Match schedule with status indicators
- Match detail with score and goal scorers
- Report dashboard

## API Integration

This app connects to the AYO Football Backend API. Make sure the backend is running before using the app.

### API Endpoints Used

- `POST /auth/login` - User login
- `POST /auth/register` - User registration
- `GET /teams` - List teams
- `GET /players` - List players
- `GET /matches` - List matches
- `GET /reports/matches` - Match reports

## Architecture

The app follows Clean Architecture principles:

1. **Presentation Layer** (Cubit + Pages)
   - Handles UI and user interactions
   - Uses BLoC pattern with Cubit for state management

2. **Domain Layer** (Repositories + Entities)
   - Contains business logic
   - Defines repository interfaces

3. **Data Layer** (Models + Repository Implementations)
   - Implements repository interfaces
   - Handles API communication

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License.

## Related Projects

- [AYO Football Backend](https://github.com/zenkriztao/ayo-football-backend) - The backend API
