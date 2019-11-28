import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geople/helper/MapHelper.dart';
import 'package:geople/model/Location.dart';
import 'package:geople/services/geople_cloud_functions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  static final INITIAL_ZOOM = 11.0;
  static final INITIAL_POSITION = LatLng(46.948, 7.44744); //Bern
  static final UPDATE_TIMER = 10; //In seconds

  @override
  State<StatefulWidget> createState() {
    return _MapPageState();
  }
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();
  Geolocator _geolocator = Geolocator();
  Stream<Position> _positionStream;
  double _radius = 10000000; //Todo: Read
  bool _locationServiceEnabled = false;
  bool _loading = true;
  Timer _updateTimer;
  Position _currentPosition;

  Set<Marker> _markers = Set.of([
    Marker(markerId: MarkerId('testMarker')),
  ]);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  void initState() {
    _loading = true; /// ProgressIndicator anzeigen.

    /// Marker aktualisieren und einen Timer erstellen um Marker zu aktualisieren.
    _updateMarkers();
    _updateTimer = Timer.periodic(Duration(
        seconds: MapPage.UPDATE_TIMER),
        (Timer timer) => _updateMarkers()
    );

    /// Check ob LocationService an und erlaubt ist.
    _geolocator.isLocationServiceEnabled().then((enabled) {
      setState(() {
        _locationServiceEnabled = enabled;
        _loading = false;
      });


      if (_locationServiceEnabled) {
        _getUserLocation().then((position) {
          _animateCameraToPosition(
              LatLng(position.latitude, position.longitude));
        });
      }
    });
    super.initState();
  }

  @override
  dispose() {
    _updateTimer.cancel();
    super.dispose();
  }

  Future<Position> _getUserLocation() async {
    return _geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  void _updateMarkers() {
    print('update');
    GeopleCloudFunctions cf = GeopleCloudFunctions();
    _getUserLocation().then((position){
      cf.getUserListInProximity(
          Location(
              latitude: position.latitude,
              longitude: position.longitude),
          _radius)
          .then((result) {
        setState(() {
          _markers = MapHelper.createMarkersFromHttpsResult(result, context);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        (_loading)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : (!_locationServiceEnabled)
                ? Text('Not enabled')
                : GoogleMap(
                    markers: _markers,
                    myLocationEnabled: true,
                    rotateGesturesEnabled: true,
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: MapPage.INITIAL_POSITION,
                      zoom: MapPage.INITIAL_ZOOM,
                    ),
                  ),
      ],
    );
  }

  void _animateCameraToPosition(LatLng position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(zoom: MapPage.INITIAL_ZOOM, target: position)));
  }
}
