import 'package:ayo_football_app/features/team/data/models/TeamModel.dart';

class MatchModel {
  final String id;
  final String matchDate;
  final String matchTime;
  final String homeTeamId;
  final String awayTeamId;
  final int? homeScore;
  final int? awayScore;
  final String status;
  final String statusName;
  final TeamSimpleModel? homeTeam;
  final TeamSimpleModel? awayTeam;
  final List<GoalModel>? goals;
  final String? matchResult;
  final String? resultDisplay;
  final String createdAt;
  final String updatedAt;

  MatchModel({
    required this.id,
    required this.matchDate,
    required this.matchTime,
    required this.homeTeamId,
    required this.awayTeamId,
    this.homeScore,
    this.awayScore,
    required this.status,
    required this.statusName,
    this.homeTeam,
    this.awayTeam,
    this.goals,
    this.matchResult,
    this.resultDisplay,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      id: json['id'] ?? '',
      matchDate: json['match_date'] ?? '',
      matchTime: json['match_time'] ?? '',
      homeTeamId: json['home_team_id'] ?? '',
      awayTeamId: json['away_team_id'] ?? '',
      homeScore: json['home_score'],
      awayScore: json['away_score'],
      status: json['status'] ?? '',
      statusName: json['status_name'] ?? '',
      homeTeam: json['home_team'] != null
          ? TeamSimpleModel.fromJson(json['home_team'])
          : null,
      awayTeam: json['away_team'] != null
          ? TeamSimpleModel.fromJson(json['away_team'])
          : null,
      goals: json['goals'] != null
          ? (json['goals'] as List).map((g) => GoalModel.fromJson(g)).toList()
          : null,
      matchResult: json['match_result'],
      resultDisplay: json['result_display'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  bool get isCompleted => status == 'completed';
  String get scoreDisplay =>
      homeScore != null && awayScore != null ? '$homeScore - $awayScore' : 'vs';
}

class GoalModel {
  final String id;
  final String matchId;
  final String playerId;
  final String? playerName;
  final String teamId;
  final String? teamName;
  final int minute;
  final bool isOwnGoal;

  GoalModel({
    required this.id,
    required this.matchId,
    required this.playerId,
    this.playerName,
    required this.teamId,
    this.teamName,
    required this.minute,
    required this.isOwnGoal,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'] ?? '',
      matchId: json['match_id'] ?? '',
      playerId: json['player_id'] ?? '',
      playerName: json['player_name'],
      teamId: json['team_id'] ?? '',
      teamName: json['team_name'],
      minute: json['minute'] ?? 0,
      isOwnGoal: json['is_own_goal'] ?? false,
    );
  }
}
