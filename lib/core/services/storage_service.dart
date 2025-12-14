import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StorageService {
  static const String _keyOnboardingCompleted = 'onboarding_completed';
  static const String _keyFirstLaunch = 'first_launch';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  bool get isOnboardingCompleted => _prefs.getBool(_keyOnboardingCompleted) ?? false;

  Future<void> setOnboardingCompleted(bool value) async {
    await _prefs.setBool(_keyOnboardingCompleted, value);
  }

  bool get isFirstLaunch => _prefs.getBool(_keyFirstLaunch) ?? true;

  Future<void> setFirstLaunchCompleted() async {
    await _prefs.setBool(_keyFirstLaunch, false);
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences harus di-override di main');
});

final storageServiceProvider = Provider<StorageService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return StorageService(prefs);
});

final isOnboardingCompletedProvider = Provider<bool>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return storage.isOnboardingCompleted;
});
