part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class UpdateUserInformation extends UserEvent {
  final Account user;

  const UpdateUserInformation(this.user);

  @override
  List<Object> get props => [user];
}

class InitUser extends UserEvent{
  // final Account user;

  // const InitUser(this.user);

  // @override
  // List<Object> get props => [user];
}