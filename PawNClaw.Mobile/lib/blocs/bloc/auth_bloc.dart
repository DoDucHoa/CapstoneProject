import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:equatable/equatable.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  AuthBloc() : super(Unauthenticated()) {
    String? verification;
    on<VerifyPhonenumber>((event, emit) //Test Id
        {
      emit(PhoneVerified(event.phoneNumber));
    });
    on<VerifyOTP>((event, emit) async {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: event.verificationId, smsCode: event.otp);
      signInWithPhoneAuthCredential(phoneAuthCredential);
      emit(Authenticated());
    });
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    //Sign in to firebase with phone auth credential
    await _auth.signInWithCredential(phoneAuthCredential);
    //get Access Token for authen/author
    String token = await FirebaseAuth.instance.currentUser!.getIdToken();
  }
}
