import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_forecast/utils/snackbar_helper.dart';
import 'package:cloud_functions/cloud_functions.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;

  User? get user => _user;

  bool get isAuthenticated => _user != null;

  Future<void> logout() async {
    try {
      await _auth.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      throw Exception('Error logging out: $e');
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _user = userCredential.user;

      await _firestore.collection('Users').doc(_user!.uid).set({
        'email': email,
        'registrationDate': FieldValue.serverTimestamp(),
        'isEmailVerified': false,
        'isSubscribedToWeatherForecast': false,
        'subscriptionDate': null,
        'lastWeatherNotificationSent': null,
      });

      notifyListeners();
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          throw Exception('Email already in use');
        } else if (e.code == 'weak-password') {
          throw Exception('Weak password');
        } else if (e.code == 'invalid-email') {
          throw Exception('Invalid email address');
        } else {
          throw Exception('Error signing up: ${e.message}');
        }
      } else {
        throw Exception('Error signing up: $e');
      }
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
      notifyListeners();
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          throw Exception('User not found');
        } else if (e.code == 'wrong-password') {
          throw Exception('Wrong password');
        } else if (e.code == 'invalid-email') {
          throw Exception('Invalid email address');
        } else {
          throw Exception('Error signing in: ${e.message}');
        }
      } else {
        throw Exception('Error signing in: $e');
      }
    }
  }

  Future<bool> isSubscribedToWeatherForecast() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return false;
    }

    final userDoc = await _firestore.collection('Users').doc(user.uid).get();
    if (userDoc.exists) {
      return userDoc.data()?['isSubscribedToWeatherForecast'] ?? false;
    }
    return false;
  }

  void checkAuthentication(BuildContext context) {
    if (_user == null) {
      showCustomSnackbar(context, 'You are not logged in!', isSuccess: false);
      context.go('/login');
    }
  }

  Future<void> checkUserStatus() async {
    _user = _auth.currentUser;
    notifyListeners();
  }

  Future<void> sendEmailConfirmation(BuildContext context) async {
    if (_user == null) {
      showCustomSnackbar(context, 'You are not logged in!', isSuccess: false);
      return;
    }

    final String email = _user!.email ?? '';
    if (email.isEmpty) {
      showCustomSnackbar(context, 'Email not found!', isSuccess: false);
      return;
    }

    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('requestSubscription');
      await callable.call({'email': email});
    } catch (error) {
      throw Exception('$error');
    }
  }
}
