import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ayo_football_app/core/providers/CoreProviders.dart';
import 'package:ayo_football_app/features/team/data/repositories/TeamRepositoryImpl.dart';
import 'package:ayo_football_app/features/team/domain/repositories/TeamRepository.dart';
import 'package:ayo_football_app/features/team/presentation/providers/TeamState.dart';

/// Provider for TeamRepository (Single Responsibility Principle)
final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TeamRepositoryImpl(apiClient);
});

/// StateNotifier for Team (Open/Closed Principle - can be extended without modification)
class TeamNotifier extends StateNotifier<TeamState> {
  final TeamRepository _teamRepository;

  TeamNotifier(this._teamRepository) : super(TeamState.initial());

  /// Get list of teams with pagination and search
  Future<void> getTeams({bool refresh = false, String? search}) async {
    if (refresh) {
      state = state.copyWith(
        status: TeamStatus.loading,
        teams: [],
        currentPage: 1,
      );
    } else if (state.status == TeamStatus.loading) {
      return;
    } else {
      state = state.copyWith(status: TeamStatus.loading);
    }

    final response = await _teamRepository.getTeams(
      page: refresh ? 1 : state.currentPage,
      search: search,
    );

    if (response.isSuccess) {
      final teams = response.data ?? [];
      final meta = response.meta;

      state = state.copyWith(
        status: TeamStatus.loaded,
        teams: refresh ? teams : [...state.teams, ...teams],
        currentPage: (meta?.currentPage ?? 1) + 1,
        totalPages: meta?.totalPages ?? 1,
        hasMore: (meta?.currentPage ?? 1) < (meta?.totalPages ?? 1),
      );
    } else {
      state = state.copyWith(
        status: TeamStatus.error,
        errorMessage: response.message,
      );
    }
  }

  /// Load more teams (infinite scroll)
  Future<void> loadMore({String? search}) async {
    if (!state.hasMore || state.status == TeamStatus.loading) return;
    await getTeams(search: search);
  }

  /// Get team by ID
  Future<void> getTeamById(String id, {bool withPlayers = false}) async {
    state = state.copyWith(status: TeamStatus.loading);

    final response =
        await _teamRepository.getTeamById(id, withPlayers: withPlayers);

    if (response.isSuccess && response.data != null) {
      state = state.copyWith(
        status: TeamStatus.loaded,
        selectedTeam: response.data,
      );
    } else {
      state = state.copyWith(
        status: TeamStatus.error,
        errorMessage: response.message,
      );
    }
  }

  /// Create new team
  Future<bool> createTeam(Map<String, dynamic> data) async {
    state = state.copyWith(status: TeamStatus.loading);

    final response = await _teamRepository.createTeam(data);

    if (response.isSuccess) {
      await getTeams(refresh: true);
      return true;
    } else {
      state = state.copyWith(
        status: TeamStatus.error,
        errorMessage: response.message,
      );
      return false;
    }
  }

  /// Update team
  Future<bool> updateTeam(String id, Map<String, dynamic> data) async {
    state = state.copyWith(status: TeamStatus.loading);

    final response = await _teamRepository.updateTeam(id, data);

    if (response.isSuccess) {
      await getTeams(refresh: true);
      return true;
    } else {
      state = state.copyWith(
        status: TeamStatus.error,
        errorMessage: response.message,
      );
      return false;
    }
  }

  /// Delete team
  Future<bool> deleteTeam(String id) async {
    state = state.copyWith(status: TeamStatus.loading);

    final response = await _teamRepository.deleteTeam(id);

    if (response.isSuccess) {
      await getTeams(refresh: true);
      return true;
    } else {
      state = state.copyWith(
        status: TeamStatus.error,
        errorMessage: response.message,
      );
      return false;
    }
  }

  /// Clear selected team
  void clearSelectedTeam() {
    state = state.copyWith(selectedTeam: null);
  }
}

/// Provider for TeamNotifier
final teamProvider = StateNotifierProvider<TeamNotifier, TeamState>((ref) {
  final repository = ref.watch(teamRepositoryProvider);
  return TeamNotifier(repository);
});

/// Provider for list of teams (derived state)
final teamsListProvider = Provider<List>((ref) {
  return ref.watch(teamProvider).teams;
});

/// Provider for selected team (derived state)
final selectedTeamProvider = Provider((ref) {
  return ref.watch(teamProvider).selectedTeam;
});
