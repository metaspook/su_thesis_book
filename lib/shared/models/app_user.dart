import 'package:equatable/equatable.dart';
import 'package:su_thesis_book/utils/utils.dart';

/// {@template user}
/// User model.
/// * Named `AppUser` instead of `User` to prevent the same name conflict with firebase's `User` class.
/// * [AppUser.empty] represents an unauthenticated user.
/// {@endtemplate}
class AppUser extends Equatable {
  const AppUser({
    required this.id,
    this.name,
    this.role,
    this.email,
    this.phone,
    this.photoUrl,
  });

  factory AppUser.fromJson(Json json) {
    return AppUser(
      id: json['id']! as String,
      name: json['name'] as String?,
      role: json['role'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      photoUrl: json['photoUrl'] as String?,
    );
  }

  final String id;
  final String? role;
  final String? name;
  final String? email;
  final String? phone;
  final String? photoUrl;

  /// Empty user which represents an unauthenticated user.
  static const empty = AppUser(id: '');
  bool get isEmpty => this == AppUser.empty;
  bool get isNotEmpty => this != AppUser.empty;

  Json toJson() {
    return <String, Object?>{
      'id': id,
      'name': name,
      'role': role,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
    };
  }

  @override
  List<Object?> get props => [id, name, role, email, phone, photoUrl];

  @override
  bool get stringify => true;
}