import 'package:ayo_football_app/features/team/domain/entities/Team.dart';

class TeamModel {
  final String id;
  final String name;
  final String? logo;
  final int foundedYear;
  final String? address;
  final String city;
  final String createdAt;
  final String updatedAt;

  TeamModel({
    required this.id,
    required this.name,
    this.logo,
    required this.foundedYear,
    this.address,
    required this.city,
    required this.createdAt,
    required this.updatedAt,
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
