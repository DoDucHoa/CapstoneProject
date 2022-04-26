part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
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
