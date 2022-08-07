part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckingCurrentAuth extends AuthEvent {
  final User? user;

  const CheckingCurrentAuth(this.user);

  @override
  // TODO: implement props
  List<Object?> get props => [user];
}

class SignIn extends AuthEvent {
  final String email;
  final String password;

  const SignIn(this.email, this.password);

  @override
  // TODO: implement props
  List<Object?> get props => [email, password];
}

class SignOut extends AuthEvent {
  const SignOut();

  @override
  // TODO: implement props
  List<Object?> get props => super.props;
}
