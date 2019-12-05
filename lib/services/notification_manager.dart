import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geople/repositories/local/messages_repository.dart';
import 'package:geople/repositories/firebase/user_repository.dart';

import 'authentication.dart';

class NotificationService {
  NotificationService._();

  factory NotificationService() => _instance;

  static final NotificationService _instance = NotificationService._();

  final MessageRepository _repo = MessageRepository();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        UserDTO dto = new UserDTO();
        Auth auth = new Auth();
        auth
            .getCurrentUser()
            .then((user) => dto.saveToken(user.uid, newToken))
            .catchError((error) => print('GeopleError: ' + error.toString()));
      });

      _firebaseMessaging.configure(
          onMessage: _onMessage,
          //Todo: onBackgroundMessage: Einkommende Nachrichten speichern
          onResume: _onResume,
          onLaunch: _onLaunch);
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
    //Todo: Navigate
    return null;
  }

  Future<void> _onResume(Map<String, dynamic> message) {
    //Todo: Navigate
    return null;
  }

  Future<void> _onMessage(Map<String, dynamic> message) async {
    if (Platform.isAndroid) {
      _repo.saveMessageFromNotification(message);
      print("onMessage Android message: ${message.toString()}");
    } else if (Platform.isIOS) {
      //Todo: OnMessage iOS
      debugPrint("onMessage iOS foo: " + message['message']);
    }
  }
}
