import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geople/services/user_dto.dart';

class PushNotificationsManager {

  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance = PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          if (Platform.isAndroid) {
            print("onMessage Android foo: ${message.toString()}");
          } else if (Platform.isIOS) {
            debugPrint("onMessage iOS foo: " + message['message']);
          }
        },
        /**onBackgroundMessage: (Map<String, dynamic> message) async {
          print('on backgroundmessage $message');
        },*/
        onResume: (Map<String, dynamic> message) async {
          print('on resume $message');
        },
        onLaunch: (Map<String, dynamic> message) async {
          print('on launch $message');
        },
      );

      _firebaseMessaging.getToken().then((token){
        UserDTO _dto = UserDTO();
        FirebaseAuth.instance.currentUser().then((user) {
          if(user != null)
            _dto.saveToken(user.uid, token);
        });
      });

      _initialized = true;
    }
  }
}