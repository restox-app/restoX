import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:restox/api/buyers.dart';
import 'package:restox/models/buyer.dart';

class OpRet {
  final UserCredential? credential;
  final Buyer? apiUser;
  final String? errorString;
  final dynamic error;

  OpRet({
    this.credential,
    this.apiUser,
    this.errorString,
    this.error,
  });
}

class UserState {
  final bool loggedIn;
  final Buyer? buyer;
  final User? user;

  UserState({
    required this.loggedIn,
    this.buyer,
    this.user
  });
}

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier(this._ref) : super(UserState(loggedIn: FirebaseAuth.instance.currentUser != null, user: FirebaseAuth.instance.currentUser));

  final Ref _ref;

  Future<OpRet> signup(String email, String password, String name) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseAuth.instance.currentUser?.updateDisplayName(name);

      await FirebaseAuth.instance.currentUser?.getIdToken(true);

      var ret = await postBuyer();

      if (ret.error != null) {
        FirebaseAuth.instance.signOut();

        return OpRet(
          errorString: 'Unable to complete operation',
          error: ret.error,
        );
      }

      state = UserState(
        loggedIn: true,
        user: FirebaseAuth.instance.currentUser,
        buyer: ret.response,
      );

      return OpRet(
        credential: credential,
        apiUser: ret.response,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return OpRet(
          errorString: 'The Password Provided is too weak',
          error: e,
        );
      } else if (e.code == 'email-already-in-use') {
        return OpRet(
          errorString: 'An account already exists for this email',
          error: e,
        );
      }
    } catch (e) {
      return OpRet(
        errorString: 'An Unknown Error Occured',
        error: e,
      );
    }

    return OpRet();
  }

  Future<OpRet> signin(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      var ret = await postBuyer();

      if (ret.error != null) {
        FirebaseAuth.instance.signOut();

        return OpRet(
          errorString: 'Unable to complete operation',
          error: ret.error,
        );
      }

      state = UserState(
        loggedIn: true,
        user: FirebaseAuth.instance.currentUser,
        buyer: ret.response,
      );

      return OpRet(
        credential: credential,
        apiUser: ret.response,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return OpRet(
          errorString: 'No User Found for this Email',
          error: e,
        );
      } else if (e.code == 'wrong-password') {
        return OpRet(
          errorString: 'The Password Provided is incorrect',
          error: e,
        );
      }
    } catch (e) {
      return OpRet(
        errorString: 'An Unknown Error Occured',
        error: e,
      );
    }

    return OpRet();
  }

  Future<void> signout() async {
    await FirebaseAuth.instance.signOut();
    state = UserState(
      loggedIn: false,
      user: null,
      buyer: null,
    );
  }

  Future<OpRet> forgotPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'auth/user-not-found') {
        return OpRet(
          errorString: 'No User Found for this Email',
          error: e,
        );
      }
    } catch (e) {
      return OpRet(
        errorString: 'An Unknown Error Occured',
        error: e,
      );
    }

    return OpRet();
  }

  Future<void> getApiUser() async {
    var ret = await postBuyer();

    if (ret.error != null) {
      FirebaseAuth.instance.signOut();
    }

    state = UserState(
      loggedIn: true,
      user: FirebaseAuth.instance.currentUser,
      buyer: ret.response,
    );
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier(ref);
});