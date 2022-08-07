import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pncstaff_mobile_application/models/user_profile.dart';
import 'package:pncstaff_mobile_application/repositories/user/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;
  UserBloc({required UserRepository userRepository})
      : this._userRepository = userRepository,
        super(UserInitial()) {
    on<GetUserProfile>(
      (event, emit) async {
        emit(UserInitial());
        // TODO: implement event handler
        final profile = await _userRepository.getProfileById(event.id);
        emit(ProfileLoaded(profile));
      },
    );
    on<UpdateUserProfile>(
      (event, emit) async {
        emit(UserInitial());
        final result = await _userRepository.updateUserProfile(
            event.id, event.name, event.phone);
        final profile = await _userRepository.getProfileById(event.id);
        emit(ProfileLoaded(profile));
      },
    );
  }
}
