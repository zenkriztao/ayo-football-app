import 'package:flutter/foundation.dart';
import 'package:ayo_football_app/features/player/data/models/PlayerModel.dart';

/// Enum for Player operation status
enum PlayerStatus { initial, loading, loaded, error }

/// State class for Player using immutable pattern
@immutable
class PlayerState {
  final PlayerStatus status;
  final List<PlayerModel> players;
  final PlayerModel? selectedPlayer;
  final String? errorMessage;
  final int currentPage;
  final int totalPages;
  final bool hasMore;

  const PlayerState({
    this.status = PlayerStatus.initial,
    this.players = const [],
    this.selectedPlayer,
    this.errorMessage,
    this.currentPage = 1,
    this.totalPages = 1,
    this.hasMore = false,
  });

  /// Factory for initial state
  factory PlayerState.initial() => const PlayerState();

  /// Factory for loading state
  factory PlayerState.loading() => const PlayerState(status: PlayerStatus.loading);

  /// CopyWith for immutable updates
  PlayerState copyWith({
    PlayerStatus? status,
    List<PlayerModel>? players,
    PlayerModel? selectedPlayer,
    String? errorMessage,
    int? currentPage,
    int? totalPages,
    bool? hasMore,
  }) {
    return PlayerState(
      status: status ?? this.status,
      players: players ?? this.players,
      selectedPlayer: selectedPlayer ?? this.selectedPlayer,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  /// Getter to check loading
  bool get isLoading => status == PlayerStatus.loading;

  /// Getter to check error
  bool get isError => status == PlayerStatus.error;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PlayerState &&
        other.status == status &&
        listEquals(other.players, players) &&
        other.selectedPlayer == selectedPlayer &&
        other.errorMessage == errorMessage &&
        other.currentPage == currentPage &&
        other.totalPages == totalPages &&
        other.hasMore == hasMore;
  }

  @override
  int get hashCode => Object.hash(
        status,
        players,
        selectedPlayer,
        errorMessage,
        currentPage,
        totalPages,
        hasMore,
      );
}
