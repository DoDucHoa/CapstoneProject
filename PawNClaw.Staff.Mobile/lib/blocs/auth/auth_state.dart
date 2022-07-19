part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class Unauthenticated extends AuthState {
  final String error;

  const Unauthenticated(this.error);
  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class Authenticated extends AuthState {
  final Account user;

  const Authenticated(this.user);
  @override
  // TODO: implement props
  List<Object> get props => [user];
}
