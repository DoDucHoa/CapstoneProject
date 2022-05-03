import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:pawnclaw_mobile_application/models/account.dart';
import 'package:pawnclaw_mobile_application/repositories/auth/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthRepository _authRepository;
  AuthBloc({required AuthRepository authRepository})
      : this._authRepository = authRepository,
        super(InitialAuth()) {
    on<VerifyPhonenumber>((event, emit) //Test Id
        {
      emit(PhoneVerified(event.phoneNumber));
    });
    on<VerifyOTP>((event, emit) async {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: event.verificationId, smsCode: event.otp);
      final account = await signInWithPhoneAuthCredential(phoneAuthCredential);
      account == null ? emit(Unauthenticated()) : emit(Authenticated(account));
    });
    on<CheckingCurrentAuth>((event, emit) async {
      if (event.user == null)
        emit(Unauthenticated());
      else {
        final account = await signInWithToken();
        account == null
            ? emit(Unauthenticated())
            : emit(Authenticated(account));
      }
    });
    on<SignOut>(
      (event, emit) async {
        await _authRepository.signOut();
        Navigator.popUntil(event.context, ModalRoute.withName("/"));
        emit(Unauthenticated());
      },
    );
  }

  Future<Account?> signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    //Sign in to firebase with phone auth credential
    await _auth.signInWithCredential(phoneAuthCredential);
    String token = await FirebaseAuth.instance.currentUser!.getIdToken();
    var account = await _authRepository.signIn(token: token);
    return account;
  }

  Future<Account?> signInWithToken() async {
    String token = await FirebaseAuth.instance.currentUser!.getIdToken();
    var account = await _authRepository.signIn(token: token);
    return account;
  }
}
