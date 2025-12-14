import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ayo_football_app/core/api/ApiClient.dart';

/// Provider for FlutterSecureStorage (Singleton)
/// Applying Dependency Inversion Principle
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

/// Provider for ApiClient (Singleton)
/// Applying Dependency Inversion Principle - depends on abstraction
final apiClientProvider = Provider<ApiClient>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return ApiClient(storage: storage);
});

/// Provider for Dio instance if needed directly
/// Following Interface Segregation Principle
final dioProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return apiClient;
});
