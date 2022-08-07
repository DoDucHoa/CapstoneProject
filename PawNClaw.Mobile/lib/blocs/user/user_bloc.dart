import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:pawnclaw_mobile_application/models/account.dart';
import 'package:pawnclaw_mobile_application/models/customer.dart';

import '../../repositories/auth/auth_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  AuthRepository _authRepository = AuthRepository();
  UserBloc() : super(UserInitial()) {
    on<UpdateUserInformation>((event, emit) {
      //to-do
      emit(UserUpdated(event.user, null));
    });

    on<InitUser>(
      (event, emit) async {
        final account = await signInWithToken();
        if (account != null) {
          
          var customer = await _authRepository.getCustomerInfo(account.id!);
          print(customer!.toJson());
          emit(UserUpdated(account, customer));
        } else
          emit(UserInitial());
      },
    );
  }

  Future<Account?> signInWithToken() async {
    String token = await FirebaseAuth.instance.currentUser!.getIdToken();
    var account = await _authRepository.signIn(token: token);
    return account;
  }
}
