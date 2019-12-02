import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geople/helper/MapHelper.dart';
import 'package:geople/model/Location.dart';
import 'package:geople/services/authentication.dart';
import 'package:geople/services/geople_cloud_functions.dart';
import 'package:geople/widgets/form_text_field.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:toast/toast.dart';

class MapPage extends StatefulWidget {
  static final INITIAL_ZOOM = 15.0;
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
  double _radius = 10000000; //Todo: Read
  bool _locationServiceEnabled = false;
  Timer _updateTimer;

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
    /// Marker aktualisieren und einen Timer erstellen um Marker zu aktualisieren.
    _updateMarkers();
    _updateTimer = Timer.periodic(Duration(seconds: MapPage.UPDATE_TIMER),
        (Timer timer) => _updateMarkers());

    _buildOfGeolocatorState();

    super.didChangeDependencies();
  }

  @override
  dispose() {
    _updateTimer.cancel();
    super.dispose();
  }

  _buildOfGeolocatorState() {
    /// Check ob LocationService an und erlaubt ist.
    _geolocator.isLocationServiceEnabled().then((enabled) {
      setState(() {
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
              "LocationService is not enabled", //Todo: translate
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
            )
          ],
        ),
      ),
    );
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
    GeopleCloudFunctions cf = GeopleCloudFunctions();
    Auth auth = Auth();
    _getUserLocation().then((position) {
      cf.getUserListInProximity(
              Location(
                  latitude: position.latitude, longitude: position.longitude),
              _radius)
          .then((result) {
        _markers = MapHelper.createMarkersFromHttpsResult(result, context);
        cf
            .getGeoMessagesInProximity(
                Location(
                    latitude: position.latitude, longitude: position.longitude),
                _radius)
            .then((result) {
          auth.getCurrentUser().then((user) {
            setState(() {
              _markers.addAll(MapHelper.createMarkersFromGeoMessagesHttpsResult(
                  result, context, user.uid));
            });
          });
        });
      });
    });
  }
}
