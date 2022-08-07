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
  final Customer? customer;
  const Authenticated(this.user, this.customer);

  @override
  // TODO: implement props
  List<Object?> get props => [user, customer];
}

class Unsigned extends AuthState {
  final String phone;

  const Unsigned(this.phone);

  @override
  // TODO: implement props
  List<Object?> get props => [phone];
}

