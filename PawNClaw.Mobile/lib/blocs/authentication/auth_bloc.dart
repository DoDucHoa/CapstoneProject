import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:pawnclaw_mobile_application/models/account.dart';
import 'package:pawnclaw_mobile_application/models/customer.dart';
import 'package:pawnclaw_mobile_application/repositories/auth/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthRepository _authRepository;
  AuthBloc({required AuthRepository authRepository})
      : this._authRepository = authRepository,
        super(Loading()) {
    on<VerifyPhonenumber>((event, emit) async {
      // var verificationId = await verifyPhone(event.phoneNumber);
      emit(PhoneVerified(event.phoneNumber, null));
    });
    on<VerifyOTP>((event, emit) async {
      emit(Loading());
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: event.verificationId, smsCode: event.otp);
      final result = await signInWithPhoneAuthCredential(phoneAuthCredential);
      if (result == "Error")
        emit(PhoneVerified(
            event.phone, "Authentication failed, please check your OTP!"));
      else if (result is Account) {
        print('at verify otp');
        emit(Loading());
        var customer = await _authRepository.getCustomerInfo(result.id!);
        if (customer != null) emit(Authenticated(result, customer));
      } else
        emit(Unsigned(event.phone));
    });
    on<CheckingCurrentAuth>((event, emit) async {
      emit(Loading());
      if (event.user == null)
        emit(Unauthenticated());
      else {
        // print(event.user!.toString());
        final account = await signInWithToken();
        if (account != null) {
          print('at check auth');
          emit(Loading());
          var customer = await _authRepository.getCustomerInfo(account.id!);
          print('customer: ${account.id}');
          if (customer != null) emit(Authenticated(account, customer));
        } else
          emit(Unauthenticated());
      }
    });
    on<SignOut>(
      (event, emit) async {
        emit(Loading());
        await _authRepository.signOut();
        emit(Unauthenticated());
        Navigator.popUntil(event.context, ModalRoute.withName("/"));
      },
    );
    on<SignUp>((event, emit) async {
      emit(Loading());
      var token = await FirebaseAuth.instance.currentUser!.getIdToken();
      final account = await _authRepository.signUp(
        token: token,
        name: event.name,
        phone: event.phone,
        email: event.email,
        birthday: event.birthday,
      );
      if (account != null) {
        print('at sign up');
        emit(Loading());
        var customer = await _authRepository.getCustomerInfo(account.id!);
        if (customer != null) emit(Authenticated(account, customer));
      } else
        emit(Unauthenticated());
    });

    on<UpdateProfile>((event, emit) {
      emit(Authenticated(event.account, event.customer));
    });
  }

  Future<dynamic> signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    //Sign in to firebase with phone auth credential
    try {
      await _auth.signInWithCredential(phoneAuthCredential);
      String token = await FirebaseAuth.instance.currentUser!.getIdToken();
      print(token);
      var account = await _authRepository.signIn(token: token);
      return account;
    } on Exception catch (e) {
      return "Error";
    }
  }

  Future<Account?> signInWithToken() async {
    String token = await FirebaseAuth.instance.currentUser!.getIdToken();
    var account = await _authRepository.signIn(token: token);
    return account;
  }

  Future<String?> verifyPhone(String phoneNumber) async {
    var id;
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) async {},
        verificationFailed: (verificationFailed) async {},
        codeSent: (verificationId, resendingToken) async {
          id = verificationId;
        },
        codeAutoRetrievalTimeout: (verificationId) async {});
    //print('verify phone:' + verificationId);
    return id;
  }
}
