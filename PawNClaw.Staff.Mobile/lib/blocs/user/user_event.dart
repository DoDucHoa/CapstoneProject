part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetUserProfile extends UserEvent {
  final int id;

  const GetUserProfile({required this.id});

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class UpdateUserProfile extends UserEvent {
  final int id;
  final String name;
  final String phone;

  const UpdateUserProfile(this.id, this.name, this.phone);

  @override
  // TODO: implement props
  List<Object> get props => [id, name, phone];
}

// class ChangePassword extends UserEvent {
//   final String oldPassword;
//   final String newPassword;

//   const 
// }
