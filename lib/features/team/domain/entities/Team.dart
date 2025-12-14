import 'package:flutter/foundation.dart';

/// Entity class for Team
/// Using immutable pattern without external dependencies
@immutable
class Team {
  final String id;
  final String name;
  final String? logo;
  final int foundedYear;
  final String? address;
  final String city;

  const Team({
    required this.id,
    required this.name,
    this.logo,
    required this.foundedYear,
    this.address,
    required this.city,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Team &&
        other.id == id &&
        other.name == name &&
        other.logo == logo &&
        other.foundedYear == foundedYear &&
        other.address == address &&
        other.city == city;
  }

  @override
  int get hashCode => Object.hash(id, name, logo, foundedYear, address, city);
}
