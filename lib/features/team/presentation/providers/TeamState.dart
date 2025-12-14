import 'package:flutter/foundation.dart';
import 'package:ayo_football_app/features/team/data/models/TeamModel.dart';

/// Enum for Team operation status
enum TeamStatus { initial, loading, loaded, error }

/// State class for Team using immutable pattern
@immutable
class TeamState {
  final TeamStatus status;
  final List<TeamModel> teams;
  final TeamModel? selectedTeam;
  final String? errorMessage;
  final int currentPage;
  final int totalPages;
  final bool hasMore;

  const TeamState({
    this.status = TeamStatus.initial,
    this.teams = const [],
    this.selectedTeam,
    this.errorMessage,
    this.currentPage = 1,
    this.totalPages = 1,
    this.hasMore = false,
  });

  /// Factory for initial state
  factory TeamState.initial() => const TeamState();

  /// Factory for loading state
  factory TeamState.loading() => const TeamState(status: TeamStatus.loading);

  /// CopyWith for immutable updates
  TeamState copyWith({
    TeamStatus? status,
    List<TeamModel>? teams,
    TeamModel? selectedTeam,
    String? errorMessage,
    int? currentPage,
    int? totalPages,
    bool? hasMore,
  }) {
    return TeamState(
      status: status ?? this.status,
      teams: teams ?? this.teams,
      selectedTeam: selectedTeam ?? this.selectedTeam,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  /// Getter to check loading status
  bool get isLoading => status == TeamStatus.loading;

  /// Getter to check error status
  bool get isError => status == TeamStatus.error;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TeamState &&
        other.status == status &&
        listEquals(other.teams, teams) &&
        other.selectedTeam == selectedTeam &&
        other.errorMessage == errorMessage &&
        other.currentPage == currentPage &&
        other.totalPages == totalPages &&
        other.hasMore == hasMore;
  }

  @override
  int get hashCode => Object.hash(
        status,
        teams,
        selectedTeam,
        errorMessage,
        currentPage,
        totalPages,
        hasMore,
      );
}
