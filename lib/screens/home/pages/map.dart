import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  static final INITIAL_ZOOM = 11.0;
  static final INITIAL_POSITION = LatLng(46.948, 7.44744); //Bern

  @override
  State<StatefulWidget> createState() {
    return _MapPageState();
  }
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();
  Geolocator _geolocator = Geolocator();
  Stream<Position> _positionStream;
  bool _locationServiceEnabled = false;
  bool _loading = true;
  Set<Marker> _markers = Set.of([
    Marker(markerId: MarkerId('testMarker')),
  ]);
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  void initState() {
    _loading = true;
    super.initState();
    _geolocator.isLocationServiceEnabled().then((enabled) {
      setState(() {
        _locationServiceEnabled = enabled;
        _loading = false;
      });
      _geolocator.getPositionStream().listen((position) {
        print(position.toString());
      });

      if(_locationServiceEnabled){
        _getUserLocation().then((position){
          _animateCameraToPosition(LatLng(position.latitude, position.longitude));
        });
      }
    });
  }

  Future<Position> _getUserLocation() async {
    return _geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  }

  @override
  Widget build(BuildContext context) {
    return (_loading)
    ? Center(child: CircularProgressIndicator(),)
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
      );
  }

  void _animateCameraToPosition(LatLng position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        zoom: MapPage.INITIAL_ZOOM,
        target: position
      )
    ));
  }
}
