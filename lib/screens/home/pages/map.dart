import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geople/app_localizations.dart';
import 'package:geople/helper/MapHelper.dart';
import 'package:geople/model/Location.dart';
import 'package:geople/repositories/firebase/user_repository.dart';
import 'package:geople/services/authentication.dart';
import 'package:geople/services/geople_cloud_functions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapPage extends StatefulWidget {
  static const INITIAL_ZOOM = 15.0;
  static const INITIAL_POSITION = LatLng(46.948, 7.44744); //Bern
  static const UPDATE_TIMER = 10; //In seconds

  @override
  State<StatefulWidget> createState() {
    return _MapPageState();
  }
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();
  Geolocator _geolocator = Geolocator();
  double _radius = 0;
  bool _locationServiceEnabled = false;
  Timer _updateTimer;
  bool _ghost = false;
  bool _isUpdating = false;

  Set<Marker> _markers = Set.of([
    Marker(markerId: MarkerId('testMarker')),
  ]);

  @override
  void initState() {
    /// ProgressIndicator anzeigen.
    super.initState();
  }

  @override
  void didChangeDependencies() {
    //Todo: Aus PrefReferences ghostmode lesen
    // _ghost = Prjid
    // _evaluateGhostMode();
    /// Marker aktualisieren und einen Timer erstellen um Marker zu aktualisieren.
    _radius = 0;
    _updateMarkers();
    _startTimer();

    _buildOfGeolocatorState();

    super.didChangeDependencies();
  }

  @override
  dispose() {
    _updateTimer.cancel();
    super.dispose();
  }

  _startTimer() {
    _updateTimer = Timer.periodic(Duration(seconds: MapPage.UPDATE_TIMER), (_) {
      if (mounted) _updateMarkers();
    });
  }

  _buildOfGeolocatorState() {
    /// Check ob LocationService an und erlaubt ist.
    _geolocator.isLocationServiceEnabled().then((enabled) {
      if (mounted) setState(() {
        _locationServiceEnabled = enabled;
      });
      if (_locationServiceEnabled) {
        _getUserLocation().then((position) {
          _animateCameraToPosition(
              LatLng(position.latitude, position.longitude));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        (!_locationServiceEnabled)
            ? _buildLocationServiceNotEnabled()
            : Stack(
                children: <Widget>[
                  GoogleMap(
                    markers: _markers,
                    myLocationEnabled: true,
                    rotateGesturesEnabled: true,
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: MapPage.INITIAL_POSITION,
                      zoom: MapPage.INITIAL_ZOOM,
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: <Widget>[
                          Material(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            child: IconButton(
                              iconSize: 27,
                              icon: Icon(
                                !_ghost
                                    ? Icons.location_on
                                    : Icons.location_off,
                                color: !_ghost ? Colors.black : Colors.black54,
                              ),
                              onPressed: () {
                                _ghost = !_ghost;
                                _evaluateGhostMode();
                              },
                            ),
                          ),
                          Visibility(
                            visible: _isUpdating,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: SizedBox(
                                width: 25,
                                height: 25,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
      ],
    );
  }

  Widget _buildLocationServiceNotEnabled() {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Icon(
              Icons.location_off,
              color: Colors.black54,
              size: 100,
            ),
            Text(
              AppLocalizations.of(context).translate('info_localization_off'),
              style: Theme.of(context).textTheme.body1,
            ),
            Padding(
              padding: EdgeInsets.only(top: 50),
              child: IconButton(
                icon: Icon(
                  Icons.refresh,
                ),
                iconSize: 35,
                onPressed: () {
                  _buildOfGeolocatorState();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _evaluateGhostMode() {
    if (mounted) setState(() {
      if (_ghost) {
        _markers.clear();
        _updateTimer.cancel();
        _isUpdating = false;

          UserDTO repo = UserDTO();
          Auth auth = Auth();
          auth.getCurrentUser().then((user) {
            repo.clearLocation(user.uid);
          });
        } else {
          _updateMarkers();
          _startTimer();
        }
      });
  }

  void _animateCameraToPosition(LatLng position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(zoom: MapPage.INITIAL_ZOOM, target: position)));
  }

  Future<Position> _getUserLocation() async {
    return _geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _updateMarkers() {
    if (mounted) setState(() {
      _isUpdating = true;
    });
    GeopleCloudFunctions cf = GeopleCloudFunctions();
    Auth auth = Auth();
    if (mounted) {
      _getUserLocation().then((position) async {
        if (_radius == 0) {
          await SharedPreferences.getInstance().then((pref) {
            int value = pref.getInt("Radius");
            if (value != null) {
              if (mounted) setState(() {
                _radius = (value).toDouble() * 1000;
              });
            }
          });
        }
        print(_radius);
        cf.getUserListInProximity(
                Location(
                    latitude: position.latitude, longitude: position.longitude),
                _radius)
            .then((result) {
          _markers = MapHelper.createMarkersFromHttpsResult(result, context);
          cf
              .getGeoMessagesInProximity(
                  Location(
                      latitude: position.latitude,
                      longitude: position.longitude),
                  _radius)
              .then((result) {
            auth.getCurrentUser().then((user) {
              if (mounted) setState(() {
                if (!_ghost)
                  _markers.addAll(
                      MapHelper.createMarkersFromGeoMessagesHttpsResult(
                          result, context, user.uid));
                _isUpdating = false;
              });
            });
          });
        });
      });
    }
  }
}
