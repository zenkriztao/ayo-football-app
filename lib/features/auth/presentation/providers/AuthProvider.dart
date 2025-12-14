import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ayo_football_app/core/providers/CoreProviders.dart';
import 'package:ayo_football_app/features/auth/data/repositories/AuthRepositoryImpl.dart';
import 'package:ayo_football_app/features/auth/domain/repositories/AuthRepository.dart';
import 'package:ayo_football_app/features/auth/presentation/providers/AuthState.dart';

/// Provider for AuthRepository (Single Responsibility - only handles repository)
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRepositoryImpl(apiClient);
});

/// StateNotifier for Auth (applying Open/Closed Principle)
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthNotifier(this._authRepository, this._ref) : super(AuthState.initial());

  /// Check authentication status when app starts
  Future<void> checkAuthStatus() async {
    final apiClient = _ref.read(apiClientProvider);
    final token = await apiClient.getToken();

    if (token != null) {
      await getProfile();
    } else {
      state = AuthState.unauthenticated();
    }
  }

  /// Login with email and password
  Future<void> login(String email, String password) async {
    state = AuthState.loading();

    final response = await _authRepository.login(email, password);

    if (response.isSuccess && response.data != null) {
      final apiClient = _ref.read(apiClientProvider);
      await apiClient.setToken(response.data!.token);
      state = AuthState.authenticated(response.data!.user);
    } else {
      state = AuthState.error(response.message);
    }
  }

  /// Register new user
  Future<void> register(String name, String email, String password) async {
    state = AuthState.loading();

    final response = await _authRepository.register(name, email, password);

    if (response.isSuccess) {
      state = AuthState.unauthenticated();
    } else {
      state = AuthState.error(response.message);
    }
  }

  /// Get currently logged in user profile
  Future<void> getProfile() async {
    state = AuthState.loading();

    final response = await _authRepository.getProfile();

    if (response.isSuccess && response.data != null) {
      state = AuthState.authenticated(response.data!);
    } else {
      final apiClient = _ref.read(apiClientProvider);
      await apiClient.clearToken();
      state = AuthState.unauthenticated();
    }
  }

  /// Logout current user
  Future<void> logout() async {
    final apiClient = _ref.read(apiClientProvider);
    await apiClient.clearToken();
    state = AuthState.unauthenticated();
  }
}

/// Provider for AuthNotifier
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository, ref);
});

/// Provider to check if user is admin (Derived State)
final isAdminProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.isAdmin;
});

/// Provider to check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.isAuthenticated;
});
