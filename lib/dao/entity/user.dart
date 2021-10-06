import 'package:json_annotation/json_annotation.dart';
/*
// use "flutter pub run build_runner build" to generate file movie.g.dart
// or use "flutter pub run build_runner watch"to follow changes in your files
*/
part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String firstName;
  final String lastName;
  final String patronymic;
  final String username;
  final String email;
  // final String password;
  final String role;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.patronymic,
    required this.username,
    required this.email,
    required this.role,
  });

  // final int id;
  // final String name;
  // final String role;
  // final bool active;
  // final DateTime registerDate;

  // User({
  //   required this.id,
  //   required this.name,
  //   required this.role,
  //   required this.active,
  //   required this.registerDate,
  // });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
