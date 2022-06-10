part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();
  
  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserUpdated extends UserState {
  final Account user;

  const UserUpdated(this.user);

  @override
  List<Object> get props => [user];
}