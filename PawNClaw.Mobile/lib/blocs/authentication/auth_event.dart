part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CheckingCurrentAuth extends AuthEvent {
  final User? user;

  const CheckingCurrentAuth(this.user);

  @override
  // TODO: implement props
  List<Object?> get props => [user];
}

class VerifyPhonenumber extends AuthEvent {
  final String phoneNumber;

  const VerifyPhonenumber(this.phoneNumber);
  @override
  // TODO: implement props
  List<Object?> get props => [phoneNumber];
}

class VerifyOTP extends AuthEvent {
  final String verificationId;
  final String otp;

  const VerifyOTP(this.verificationId, this.otp);
  @override
  // TODO: implement props
  List<Object?> get props => [verificationId, otp];
}

class SignOut extends AuthEvent {
  final context;

  const SignOut(this.context);
  @override
  // TODO: implement props
  List<Object?> get props => [context];
}
