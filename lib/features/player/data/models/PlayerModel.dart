import 'package:ayo_football_app/features/player/domain/entities/Player.dart';
import 'package:ayo_football_app/features/team/data/models/TeamModel.dart';

class PlayerModel {
  final String id;
  final String teamId;
  final String name;
  final double height;
  final double weight;
  final String position;
  final String positionName;
  final int jerseyNumber;
  final TeamSimpleModel? team;
  final String createdAt;
  final String updatedAt;

  PlayerModel({
    required this.id,
    required this.teamId,
    required this.name,
    required this.height,
    required this.weight,
    required this.position,
    required this.positionName,
    required this.jerseyNumber,
    this.team,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      id: json['id'] ?? '',
      teamId: json['team_id'] ?? '',
      name: json['name'] ?? '',
      height: (json['height'] ?? 0).toDouble(),
      weight: (json['weight'] ?? 0).toDouble(),
      position: json['position'] ?? '',
      positionName: json['position_name'] ?? '',
      jerseyNumber: json['jersey_number'] ?? 0,
      team: json['team'] != null ? TeamSimpleModel.fromJson(json['team']) : null,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'team_id': teamId,
      'name': name,
      'height': height,
      'weight': weight,
      'position': position,
      'jersey_number': jerseyNumber,
    };
  }

  Player toEntity() {
    return Player(
      id: id,
      teamId: teamId,
      name: name,
      height: height,
      weight: weight,
      position: position,
      positionName: positionName,
      jerseyNumber: jerseyNumber,
    );
  }

  static const Map<String, String> positions = {
    'forward': 'Penyerang',
    'midfielder': 'Gelandang',
    'defender': 'Bertahan',
    'goalkeeper': 'Penjaga Gawang',
  };
}
