part of 'sign_up_bloc.dart';

enum SignUpStatus {
  initial,
  editing,
  loading,
  success,
  failure;

  bool get isLoading => this == SignUpStatus.loading;
  bool get hasMessage =>
      this == SignUpStatus.success || this == SignUpStatus.failure;
}

final class SignUpState extends Equatable {
  const SignUpState({
    this.status = SignUpStatus.initial,
    this.statusMsg = '',
    this.name = '',
    this.email = '',
    this.password = '',
    this.phone = '',
    this.role = '',
    this.roles = const <String>[],
    this.photoPath = '',
    this.obscurePassword = true,
  });

  final SignUpStatus status;
  final String statusMsg;
  final String name;
  final String email;
  final String password;
  final String phone;
  final String role;
  final List<String> roles;
  final String photoPath;
  final bool obscurePassword;

  SignUpState copyWith({
    SignUpStatus? status,
    String? statusMsg,
    String? name,
    String? email,
    String? password,
    String? phone,
    String? role,
    List<String>? roles,
    String? photoPath,
    bool? obscurePassword,
  }) {
    return SignUpState(
      status: status ?? this.status,
      statusMsg: statusMsg ?? this.statusMsg,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      roles: roles ?? this.roles,
      photoPath: photoPath ?? this.photoPath,
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }

  @override
  List<Object> get props {
    return [
      status,
      statusMsg,
      name,
      email,
      password,
      phone,
      role,
      roles,
      photoPath,
      obscurePassword,
    ];
  }
}