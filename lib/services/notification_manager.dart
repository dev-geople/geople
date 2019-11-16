import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geople/services/user_dto.dart';

import 'authentication.dart';

class NotificationService {
  NotificationService._();

  factory NotificationService() => _instance;

  static final NotificationService _instance =
      NotificationService._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        UserDTO dto = new UserDTO();
        Auth auth = new Auth();
        auth.getCurrentUser()
            .then((user) => dto.saveToken(user.uid, newToken))
            .catchError((error) => print('GeopleError: ' + error.toString()));
      });

      _firebaseMessaging.configure(
        onMessage: _onMessage,
        //onBackgroundMessage: _onBackgroundMessage
        onResume: _onResume,
        onLaunch: _onLaunch
      );
    }

    _firebaseMessaging.getToken().then((token) {
      UserDTO _dto = UserDTO();
      FirebaseAuth.instance.currentUser().then((user) {
        if (user != null) _dto.saveToken(user.uid, token);
      });
    });

    _initialized = true;
  }


  Future<void> _onLaunch(Map<String, dynamic> message) {
    print("onLaunch $message");
    return null;
  }

  Future<void> _onResume(Map<String, dynamic> message) {
    print("onResume $message");
    return null;
  }

  Future<void> _onMessage(Map<String, dynamic> message) async {
    if (Platform.isAndroid) {
      print("onMessage Android foo: ${message.toString()}");
    } else if (Platform.isIOS) {
      debugPrint("onMessage iOS foo: " + message['message']);
    }
  }
}
