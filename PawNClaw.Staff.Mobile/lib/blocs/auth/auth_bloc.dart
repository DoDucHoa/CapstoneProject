import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:pncstaff_mobile_application/models/account.dart';
import 'package:pncstaff_mobile_application/repositories/auth/auth_repository.dart';
import 'package:pncstaff_mobile_application/repositories/center/center_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  AuthBloc({required AuthRepository authRepository})
      : this._authRepository = authRepository,
        super(AuthInitial()) {
    on<CheckingCurrentAuth>((event, emit) async {
      emit(AuthInitial());
      if (event.user == null)
        emit(Unauthenticated(""));
      else {
        final account = await signInWithToken();
        account?.petCenter =
            await CenterRepository().getCenterByStaff(account.id!);
        account != null
            ? emit(Authenticated(account))
            : emit(Unauthenticated("*Tài khoản chưa kích hoạt"));
      }
    });
    on<SignIn>((event, emit) async {
      emit(AuthInitial());
      try {
        var credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: event.email, password: event.password);
      } catch (_) {
        emit(Unauthenticated("*Tài khoản không tồn tại"));
      }
      var token = await FirebaseAuth.instance.currentUser!.getIdToken();
      final account = await _authRepository.signIn(token: token);
      account?.petCenter =
          await CenterRepository().getCenterByStaff(account.id!);
      account != null
          ? emit(Authenticated(account))
          : emit(Unauthenticated("*Tài khoản không tồn tại"));
    });
  }

  Future<Account?> signInWithToken() async {
    String token = await FirebaseAuth.instance.currentUser!.getIdToken();
    var account = await _authRepository.signIn(token: token);
    return account;
  }
}
