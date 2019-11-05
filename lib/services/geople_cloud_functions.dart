import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';

class GeopleCloudFunctions {
  static const FUNCTIONS_REGION = 'europe-west2';
  static final GeopleCloudFunctions _instance = GeopleCloudFunctions._internal();
  factory GeopleCloudFunctions() => _instance;
  CloudFunctions cf;

  GeopleCloudFunctions._internal() {
    this.cf = CloudFunctions(app: FirebaseApp.instance, region: FUNCTIONS_REGION);
  }

  sendFriendRequest(String requestUid) async {
    try {
      HttpsCallable callable =
          cf.getHttpsCallable(functionName: 'sendFriendRequest');
      return await callable.call(<String, dynamic>
      {
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
}
