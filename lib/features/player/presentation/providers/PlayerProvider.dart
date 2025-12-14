import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ayo_football_app/core/providers/CoreProviders.dart';
import 'package:ayo_football_app/features/player/data/repositories/PlayerRepositoryImpl.dart';
import 'package:ayo_football_app/features/player/domain/repositories/PlayerRepository.dart';
import 'package:ayo_football_app/features/player/presentation/providers/PlayerState.dart';

/// Provider for PlayerRepository (Single Responsibility Principle)
final playerRepositoryProvider = Provider<PlayerRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return PlayerRepositoryImpl(apiClient);
});

/// StateNotifier for Player
class PlayerNotifier extends StateNotifier<PlayerState> {
  final PlayerRepository _playerRepository;

  PlayerNotifier(this._playerRepository) : super(PlayerState.initial());

  /// Get list players with pagination and search
  Future<void> getPlayers({
    bool refresh = false,
    String? search,
    String? teamId,
  }) async {
    if (refresh) {
      state = state.copyWith(
        status: PlayerStatus.loading,
        players: [],
        currentPage: 1,
      );
    } else if (state.status == PlayerStatus.loading) {
      return;
    } else {
      state = state.copyWith(status: PlayerStatus.loading);
    }

    final response = await _playerRepository.getPlayers(
      page: refresh ? 1 : state.currentPage,
      search: search,
      teamId: teamId,
    );

    if (response.isSuccess) {
      final players = response.data ?? [];
      final meta = response.meta;

      state = state.copyWith(
        status: PlayerStatus.loaded,
        players: refresh ? players : [...state.players, ...players],
        currentPage: (meta?.currentPage ?? 1) + 1,
        totalPages: meta?.totalPages ?? 1,
        hasMore: (meta?.currentPage ?? 1) < (meta?.totalPages ?? 1),
      );
    } else {
      state = state.copyWith(
        status: PlayerStatus.error,
        errorMessage: response.message,
      );
    }
  }

  /// Get player by ID
  Future<void> getPlayerById(String id) async {
    state = state.copyWith(status: PlayerStatus.loading);

    final response = await _playerRepository.getPlayerById(id);

    if (response.isSuccess && response.data != null) {
      state = state.copyWith(
        status: PlayerStatus.loaded,
        selectedPlayer: response.data,
      );
    } else {
      state = state.copyWith(
        status: PlayerStatus.error,
        errorMessage: response.message,
      );
    }
  }

  /// Create new player
  Future<bool> createPlayer(Map<String, dynamic> data) async {
    state = state.copyWith(status: PlayerStatus.loading);

    final response = await _playerRepository.createPlayer(data);

    if (response.isSuccess) {
      await getPlayers(refresh: true);
      return true;
    } else {
      state = state.copyWith(
        status: PlayerStatus.error,
        errorMessage: response.message,
      );
      return false;
    }
  }

  /// Update player
  Future<bool> updatePlayer(String id, Map<String, dynamic> data) async {
    state = state.copyWith(status: PlayerStatus.loading);

    final response = await _playerRepository.updatePlayer(id, data);

    if (response.isSuccess) {
      await getPlayers(refresh: true);
      return true;
    } else {
      state = state.copyWith(
        status: PlayerStatus.error,
        errorMessage: response.message,
      );
      return false;
    }
  }

  /// Delete player
  Future<bool> deletePlayer(String id) async {
    state = state.copyWith(status: PlayerStatus.loading);

    final response = await _playerRepository.deletePlayer(id);

    if (response.isSuccess) {
      await getPlayers(refresh: true);
      return true;
    } else {
      state = state.copyWith(
        status: PlayerStatus.error,
        errorMessage: response.message,
      );
      return false;
    }
  }

  /// Clear selected player
  void clearSelectedPlayer() {
    state = state.copyWith(selectedPlayer: null);
  }
}

/// Provider for PlayerNotifier
final playerProvider = StateNotifierProvider<PlayerNotifier, PlayerState>((ref) {
  final repository = ref.watch(playerRepositoryProvider);
  return PlayerNotifier(repository);
});

/// Provider for selected player (derived state)
final selectedPlayerProvider = Provider((ref) {
  return ref.watch(playerProvider).selectedPlayer;
});
