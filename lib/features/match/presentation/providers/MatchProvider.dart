import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ayo_football_app/core/providers/CoreProviders.dart';
import 'package:ayo_football_app/features/match/data/repositories/MatchRepositoryImpl.dart';
import 'package:ayo_football_app/features/match/domain/repositories/MatchRepository.dart';
import 'package:ayo_football_app/features/match/presentation/providers/MatchState.dart';

/// Provider for MatchRepository (Single Responsibility Principle)
final matchRepositoryProvider = Provider<MatchRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MatchRepositoryImpl(apiClient);
});

/// StateNotifier for Match
class MatchNotifier extends StateNotifier<MatchState> {
  final MatchRepository _matchRepository;

  MatchNotifier(this._matchRepository) : super(MatchState.initial());

  /// Get list matches
  Future<void> getMatches({bool refresh = false, String? status}) async {
    // Only show loading if no data exists yet
    if (state.matches.isEmpty) {
      state = state.copyWith(status: MatchStatus.loading);
    }

    final response = await _matchRepository.getMatches(status: status);

    if (response.isSuccess) {
      state = state.copyWith(
        status: MatchStatus.loaded,
        matches: response.data ?? [],
      );
    } else {
      state = state.copyWith(
        status: MatchStatus.error,
        errorMessage: response.message,
      );
    }
  }

  /// Get match by ID
  Future<void> getMatchById(String id) async {
    // Don't change global status to avoid affecting list page
    final response = await _matchRepository.getMatchById(id);

    if (response.isSuccess && response.data != null) {
      state = state.copyWith(
        selectedMatch: response.data,
      );
    } else {
      state = state.copyWith(
        errorMessage: response.message,
      );
    }
  }

  /// Create new match
  Future<bool> createMatch(Map<String, dynamic> data) async {
    state = state.copyWith(status: MatchStatus.loading);

    final response = await _matchRepository.createMatch(data);

    if (response.isSuccess) {
      await getMatches(refresh: true);
      return true;
    } else {
      state = state.copyWith(
        status: MatchStatus.error,
        errorMessage: response.message,
      );
      return false;
    }
  }

  /// Record match result
  Future<bool> recordResult(String id, Map<String, dynamic> data) async {
    final response = await _matchRepository.recordResult(id, data);

    if (response.isSuccess && response.data != null) {
      // Update both selectedMatch and the match in the list
      final updatedMatches = state.matches.map((m) {
        if (m.id == id) {
          return response.data!;
        }
        return m;
      }).toList();

      state = state.copyWith(
        status: MatchStatus.loaded,
        matches: updatedMatches,
        selectedMatch: response.data,
      );
      return true;
    } else {
      state = state.copyWith(
        errorMessage: response.message,
      );
      return false;
    }
  }

  /// Update match
  Future<bool> updateMatch(String id, Map<String, dynamic> data) async {
    final response = await _matchRepository.updateMatch(id, data);

    if (response.isSuccess && response.data != null) {
      // Update both selectedMatch and the match in the list
      final updatedMatches = state.matches.map((m) {
        if (m.id == id) {
          return response.data!;
        }
        return m;
      }).toList();

      state = state.copyWith(
        status: MatchStatus.loaded,
        matches: updatedMatches,
        selectedMatch: response.data,
      );
      return true;
    } else {
      state = state.copyWith(
        errorMessage: response.message,
      );
      return false;
    }
  }

  /// Delete match
  Future<bool> deleteMatch(String id) async {
    final response = await _matchRepository.deleteMatch(id);

    if (response.isSuccess) {
      // Remove from list directly
      final updatedMatches = state.matches.where((m) => m.id != id).toList();
      state = state.copyWith(
        status: MatchStatus.loaded,
        matches: updatedMatches,
        clearSelectedMatch: true,
      );
      return true;
    } else {
      state = state.copyWith(
        errorMessage: response.message,
      );
      return false;
    }
  }

  /// Clear selected match
  void clearSelectedMatch() {
    state = state.copyWith(clearSelectedMatch: true);
  }
}

/// Provider for MatchNotifier
final matchProvider = StateNotifierProvider<MatchNotifier, MatchState>((ref) {
  final repository = ref.watch(matchRepositoryProvider);
  return MatchNotifier(repository);
});

/// Provider for selected match (derived state)
final selectedMatchProvider = Provider((ref) {
  return ref.watch(matchProvider).selectedMatch;
});
