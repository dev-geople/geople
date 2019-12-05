import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geople/model/Location.dart';

class GeopleCloudFunctions {
  static const FUNCTIONS_REGION = 'europe-west2';

  GeopleCloudFunctions._();

  factory GeopleCloudFunctions() => _instance;

  static final GeopleCloudFunctions _instance = GeopleCloudFunctions._();

  CloudFunctions cf =
      CloudFunctions(app: FirebaseApp.instance, region: FUNCTIONS_REGION);

  sendFriendRequest(String requestUid) async {
    try {
      HttpsCallable callable =
          cf.getHttpsCallable(functionName: 'sendFriendRequest');
      return await callable.call(<String, dynamic>{
        'request_uid': requestUid,
      });
    } on CloudFunctionsException catch (e) {
      print('CLOUD FUNCTIONS EXCEPTION');
      print(e.code);
      print(e.message);
      print(e.details);
    } catch (e) {
      print('GENERIC EXCEPTION');
    }
  }

  confirmFriendRequest(String requestUid) async {
    try {
      HttpsCallable callable =
          cf.getHttpsCallable(functionName: 'confirmFriendRequest');
      return await callable.call(<String, dynamic>{
        'request_uid': requestUid,
      });
    } on CloudFunctionsException catch (e) {
      print('CLOUD FUNCTIONS EXCEPTION');
      print(e.code);
      print(e.message);
      print(e.details);
    } catch (e) {
      print('GENERIC EXCEPTION');
    }
  }

  sendMessage(String toUid, String message) async {
    try {
      HttpsCallable callable = cf.getHttpsCallable(functionName: 'sendMessage');
      return await callable.call(<String, dynamic>{
        'message': message,
        'recepient_uid': toUid,
      });
    } on CloudFunctionsException catch (e) {
      print('CLOUD FUNCTIONS EXCEPTION');
      print(e.code);
      print(e.message);
      print(e.details);
    } catch (e) {
      print('GENERIC EXCEPTION');
    }
  }

  sendGeoMessage(Location location, String message) async {
    try {
      HttpsCallable callable =
          cf.getHttpsCallable(functionName: 'sendGeoMessage');
      print('sendGeoMessage\nMessage: ' +
          message +
          '\nLocation: ' +
          location.toString());
      return await callable.call(<String, dynamic>{
        'message': message,
        'lat': location.latitude,
        'lng': location.longitude,
      });
    } on CloudFunctionsException catch (e) {
      print('CLOUD FUNCTIONS EXCEPTION');
      print(e.code);
      print(e.message);
      print(e.details);
    } catch (e) {
      print('GENERIC EXCEPTION');
    }
  }

  Future<HttpsCallableResult> getUserListInProximity(
      Location location, double radius) async {
    try {
      HttpsCallable callable =
          cf.getHttpsCallable(functionName: 'getUserListInProximity');
      return await callable.call(<String, dynamic>{
        'lat': location.latitude,
        'lng': location.longitude,
        'radius': radius,
      });
    } on CloudFunctionsException catch (e) {
      print('CLOUD FUNCTIONS EXCEPTION');
      print(e.code);
      print(e.message);
      print(e.details);
    } catch (e) {
      print('GENERIC EXCEPTION');
    }
  }

  Future<HttpsCallableResult> getGeoMessagesInProximity(
      Location location, double radius) async {
    try {
      HttpsCallable callable =
          cf.getHttpsCallable(functionName: 'getGeoMessagesInProximity');
      return await callable.call(<String, dynamic>{
        'lat': location.latitude,
        'lng': location.longitude,
        'radius': radius,
      });
    } on CloudFunctionsException catch (e) {
      print('CLOUD FUNCTIONS EXCEPTION');
      print(e.code);
      print(e.message);
      print(e.details);
    } catch (e) {
      print('GENERIC EXCEPTION');
    }
  }
}
