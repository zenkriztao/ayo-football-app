import 'package:ayo_football_app/features/match/data/models/MatchModel.dart';
import 'package:ayo_football_app/features/team/data/models/TeamModel.dart';

/// Match report model containing detailed match statistics
class MatchReportModel {
  final MatchModel match;
  final TeamSimpleModel homeTeam;
  final TeamSimpleModel awayTeam;
  final int homeScore;
  final int awayScore;
  final String matchResult;
  final String matchResultDisplay;
  final List<GoalModel> goals;
  final TopScorerModel? topScorer;
  final int homeTeamTotalWins;
  final int awayTeamTotalWins;

  MatchReportModel({
    required this.match,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.matchResult,
    required this.matchResultDisplay,
    required this.goals,
    this.topScorer,
    required this.homeTeamTotalWins,
    required this.awayTeamTotalWins,
  });

  factory MatchReportModel.fromJson(Map<String, dynamic> json) {
    return MatchReportModel(
      match: MatchModel.fromJson(json['match'] ?? {}),
      homeTeam: TeamSimpleModel.fromJson(json['home_team'] ?? {}),
      awayTeam: TeamSimpleModel.fromJson(json['away_team'] ?? {}),
      homeScore: json['home_score'] ?? 0,
      awayScore: json['away_score'] ?? 0,
      matchResult: json['match_result'] ?? '',
      matchResultDisplay: json['match_result_display'] ?? '',
      goals: json['goals'] != null
          ? (json['goals'] as List).map((g) => GoalModel.fromJson(g)).toList()
          : [],
      topScorer: json['top_scorer'] != null
          ? TopScorerModel.fromJson(json['top_scorer'])
          : null,
      homeTeamTotalWins: json['home_team_total_wins'] ?? 0,
      awayTeamTotalWins: json['away_team_total_wins'] ?? 0,
    );
  }

  /// Check if home team won
  bool get isHomeWin => matchResult == 'home_win';

  /// Check if away team won
  bool get isAwayWin => matchResult == 'away_win';

  /// Check if it was a draw
  bool get isDraw => matchResult == 'draw';

  /// Get formatted score display
  String get scoreDisplay => '$homeScore - $awayScore';
}

/// Top scorer model for leaderboard
class TopScorerModel {
  final String playerId;
  final String playerName;
  final String teamId;
  final String teamName;
  final int goalCount;

  TopScorerModel({
    required this.playerId,
    required this.playerName,
    required this.teamId,
    required this.teamName,
    required this.goalCount,
  });

  factory TopScorerModel.fromJson(Map<String, dynamic> json) {
    return TopScorerModel(
      playerId: json['player_id'] ?? '',
      playerName: json['player_name'] ?? '',
      teamId: json['team_id'] ?? '',
      teamName: json['team_name'] ?? '',
      goalCount: json['goal_count'] ?? 0,
    );
  }
}
