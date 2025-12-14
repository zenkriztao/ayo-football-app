import 'package:flutter/foundation.dart';

/// Entity class for Player
/// Using immutable pattern without external dependencies
@immutable
class Player {
  final String id;
  final String teamId;
  final String name;
  final double height;
  final double weight;
  final String position;
  final String positionName;
  final int jerseyNumber;

  const Player({
    required this.id,
    required this.teamId,
    required this.name,
    required this.height,
    required this.weight,
    required this.position,
    required this.positionName,
    required this.jerseyNumber,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Player &&
        other.id == id &&
        other.teamId == teamId &&
        other.name == name &&
        other.height == height &&
        other.weight == weight &&
        other.position == position &&
        other.positionName == positionName &&
        other.jerseyNumber == jerseyNumber;
  }

  @override
  int get hashCode => Object.hash(
        id,
        teamId,
        name,
        height,
        weight,
        position,
        positionName,
        jerseyNumber,
      );
}
