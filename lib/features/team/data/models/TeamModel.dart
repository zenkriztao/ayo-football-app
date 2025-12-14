import 'package:ayo_football_app/features/team/domain/entities/Team.dart';

/// Simple player model for team detail
class TeamPlayerModel {
  final String id;
  final String name;
  final String position;
  final String positionName;
  final int jerseyNumber;

  TeamPlayerModel({
    required this.id,
    required this.name,
    required this.position,
    required this.positionName,
    required this.jerseyNumber,
  });

  factory TeamPlayerModel.fromJson(Map<String, dynamic> json) {
    return TeamPlayerModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      position: json['position'] ?? '',
      positionName: json['position_name'] ?? '',
      jerseyNumber: json['jersey_number'] ?? 0,
    );
  }
}

class TeamModel {
  final String id;
  final String name;
  final String? logo;
  final int foundedYear;
  final String? address;
  final String city;
  final String createdAt;
  final String updatedAt;
  final List<TeamPlayerModel>? players;

  TeamModel({
    required this.id,
    required this.name,
    this.logo,
    required this.foundedYear,
    this.address,
    required this.city,
    required this.createdAt,
    required this.updatedAt,
    this.players,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      logo: json['logo'],
      foundedYear: json['founded_year'] ?? 0,
      address: json['address'],
      city: json['city'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      players: json['players'] != null
          ? (json['players'] as List)
              .map((p) => TeamPlayerModel.fromJson(p))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'logo': logo,
      'founded_year': foundedYear,
      'address': address,
      'city': city,
    };
  }

  Team toEntity() {
    return Team(
      id: id,
      name: name,
      logo: logo,
      foundedYear: foundedYear,
      address: address,
      city: city,
    );
  }
}

class TeamSimpleModel {
  final String id;
  final String name;
  final String? logo;
  final String city;

  TeamSimpleModel({
    required this.id,
    required this.name,
    this.logo,
    required this.city,
  });

  factory TeamSimpleModel.fromJson(Map<String, dynamic> json) {
    return TeamSimpleModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      logo: json['logo'],
      city: json['city'] ?? '',
    );
  }
}
