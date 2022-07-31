part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class ProfileLoaded extends UserState {
  final UserProfile profile;

  const ProfileLoaded(this.profile);

  @override
  // TODO: implement props
  List<Object> get props => [profile];
}
