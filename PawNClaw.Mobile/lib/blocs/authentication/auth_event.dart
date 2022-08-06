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
  final String phone;

  const VerifyOTP(this.verificationId, this.otp, this.phone);
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

class SignUp extends AuthEvent {
  final String name;
  final String phone;
  final String email;
  final DateTime birthday;

  const SignUp(this.name, this.phone, this.email, this.birthday);

  @override
  // TODO: implement props
  List<Object?> get props => [name, phone, email, birthday];
}

class UpdateProfile extends AuthEvent {
  final Account account;
  final Customer customer;
  const UpdateProfile(this.account, this.customer);
  @override
  // TODO: implement props
  List<Object?> get props => [account, customer];
}