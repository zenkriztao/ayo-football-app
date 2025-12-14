import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/config/app_config.dart';
import 'core/services/storage_service.dart';
import 'app.dart';

/// Entry point untuk Staging flavor
/// Gunakan command: flutter run --flavor staging -t lib/main_staging.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Staging config
  AppConfig.staging();

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        // Override SharedPreferences provider
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const AyoFootballApp(),
    ),
  );
}
