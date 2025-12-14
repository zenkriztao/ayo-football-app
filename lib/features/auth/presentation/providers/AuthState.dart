import 'package:flutter/foundation.dart';
import 'package:ayo_football_app/features/auth/data/models/UserModel.dart';

/// Enum for authentication status
enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

/// State class for authentication using immutable pattern
@immutable
class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  /// Factory for initial state
  factory AuthState.initial() => const AuthState();

  /// Factory for loading state
  factory AuthState.loading() => const AuthState(status: AuthStatus.loading);

  /// Factory for authenticated state
  factory AuthState.authenticated(UserModel user) => AuthState(
        status: AuthStatus.authenticated,
        user: user,
      );

  /// Factory for unauthenticated state
  factory AuthState.unauthenticated() =>
      const AuthState(status: AuthStatus.unauthenticated);

  /// Factory for error state
  factory AuthState.error(String message) => AuthState(
        status: AuthStatus.error,
        errorMessage: message,
      );

  /// CopyWith for immutable updates
  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Getter to check authentication status
  bool get isAuthenticated => status == AuthStatus.authenticated;

  /// Getter to check admin status
  bool get isAdmin => user?.isAdmin ?? false;

  /// Getter to check loading status
  bool get isLoading => status == AuthStatus.loading;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthState &&
        other.status == status &&
        other.user == user &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => Object.hash(status, user, errorMessage);
}
