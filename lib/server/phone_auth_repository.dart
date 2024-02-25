import "package:firebase_auth/firebase_auth.dart";
import 'package:oxoo/constants.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;

  UserRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<void> sendOtp(
      String phoneNumber,
      Duration timeOut,
      PhoneVerificationFailed phoneVerificationFailed,
      PhoneVerificationCompleted phoneVerificationCompleted,
      PhoneCodeSent phoneCodeSent,
      PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout) async {
      try {
        _firebaseAuth.verifyPhoneNumber(
            phoneNumber: phoneNumber,
            timeout: timeOut,
            verificationCompleted: phoneVerificationCompleted,
            verificationFailed: phoneVerificationFailed,
            codeSent: phoneCodeSent,
            codeAutoRetrievalTimeout: autoRetrievalTimeout);
      }
      catch(e){
        printLog(e);
        rethrow;
      }
  }

   verifyAndLogin(
      String verificationId, String smsCode) async {
    AuthCredential authCredential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);

    return _firebaseAuth.signInWithCredential(authCredential);
  }

  Future<User?> getUser() async {
    var user =  _firebaseAuth.currentUser;
    return user;
  }
}
