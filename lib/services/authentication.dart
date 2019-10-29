import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geople/routes.dart';

// Abstrakte Klasse für AuthenticationService
abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

   /// Meldet User mit Email und Passwort an und gibt User-ID zurück.
  Future<String> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  /// Registriert einen neuen User und gibt User-ID zurück.
  /// (Confirm Password nötig!)
  Future<String> signUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  /// Gibt den im Moment eingeloggten User zurück.
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  /// Checkt ob der User eingellogt ist und leitet um, falls dies nicht
  /// der Fall ist.
  Future<void> ensureIsLoggedIn(BuildContext context) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    if(user == null) {
      Navigator.of(context).pushReplacementNamed(Routes.SIGN_IN);
    }
  }

  /// Meldet den im Moment eingeloggten User ab.
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  /// Sendet dem User eine Verifizierungsmail zu.
  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  /// Überprüft, ob der angemeldete Nutzer seine Email verifiziert hat.
  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }
}