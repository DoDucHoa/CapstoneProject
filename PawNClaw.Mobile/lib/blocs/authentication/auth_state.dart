part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {
  const AuthState();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class InitialAuth extends AuthState {}

class Unauthenticated extends AuthState {}

class PhoneVerified extends AuthState {
  final String phoneNumber;

  const PhoneVerified(this.phoneNumber);

  @override
  // TODO: implement props
  List<Object?> get props => [phoneNumber];
}

class Authenticated extends AuthState {
  final Account user;

  const Authenticated(this.user);

  @override
  // TODO: implement props
  List<Object?> get props => [user];
}
