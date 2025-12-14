import 'package:flutter/foundation.dart';
import 'package:ayo_football_app/features/match/data/models/MatchModel.dart';

/// Enum for Match operation status
enum MatchStatus { initial, loading, loaded, error }

/// State class for Match using immutable pattern
@immutable
class MatchState {
  final MatchStatus status;
  final List<MatchModel> matches;
  final MatchModel? selectedMatch;
  final String? errorMessage;

  const MatchState({
    this.status = MatchStatus.initial,
    this.matches = const [],
    this.selectedMatch,
    this.errorMessage,
  });

  /// Factory for initial state
  factory MatchState.initial() => const MatchState();

  /// Factory for loading state
  factory MatchState.loading() => const MatchState(status: MatchStatus.loading);

  /// CopyWith for immutable updates
  MatchState copyWith({
    MatchStatus? status,
    List<MatchModel>? matches,
    MatchModel? selectedMatch,
    String? errorMessage,
  }) {
    return MatchState(
      status: status ?? this.status,
      matches: matches ?? this.matches,
      selectedMatch: selectedMatch ?? this.selectedMatch,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Getter to check loading
  bool get isLoading => status == MatchStatus.loading;

  /// Getter to check error
  bool get isError => status == MatchStatus.error;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MatchState &&
        other.status == status &&
        listEquals(other.matches, matches) &&
        other.selectedMatch == selectedMatch &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => Object.hash(status, matches, selectedMatch, errorMessage);
}
