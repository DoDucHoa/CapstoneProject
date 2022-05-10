part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {
  const AuthState();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class Loading extends AuthState {}

class Unauthenticated extends AuthState {}

class PhoneVerified extends AuthState {
  final String phoneNumber;
  final String? error;

  const PhoneVerified(this.phoneNumber, this.error);

  @override
  // TODO: implement props
  List<Object?> get props => [phoneNumber, error];
}

class Authenticated extends AuthState {
  final Account user;

  const Authenticated(this.user);

  @override
  // TODO: implement props
  List<Object?> get props => [user];
}

class Unsigned extends AuthState {
  final String phone;

  const Unsigned(this.phone);

  @override
  // TODO: implement props
  List<Object?> get props => [phone];
}
