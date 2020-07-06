import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:native_device_feature/modals/place.dart';

class MapScreen extends StatefulWidget {
  static const routeName = '/map-screen';

  final PlaceLocation initialPlaceLocation;
  final bool isSelecting;

  MapScreen(
      {this.initialPlaceLocation =
          const PlaceLocation(latitude: 20.468189, longitude: 82.208100),
      this.isSelecting = false});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _pickedLocation;

  void _selectPlace(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  void initState() {
    if (!widget.isSelecting) {
      _pickedLocation = LatLng(
        widget.initialPlaceLocation.latitude,
        widget.initialPlaceLocation.longitude,
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Map',
        ),
        actions: <Widget>[
          if (widget.isSelecting && _pickedLocation != null)
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                Navigator.of(context).pop(_pickedLocation);
              },
            ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initialPlaceLocation.latitude,
            widget.initialPlaceLocation.longitude,
          ),
          zoom: 16,
        ),
        onTap: widget.isSelecting ? _selectPlace : null,
        markers: _pickedLocation == null
            ? null
            : {
                Marker(
                  markerId: MarkerId(
                    'm1',
                  ),
                  position: _pickedLocation,
                ),
              },
      ),
    );
  }
}
