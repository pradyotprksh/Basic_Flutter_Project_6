import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:native_device_feature/helpers/location_helper.dart';
import 'package:native_device_feature/screen/map_screen.dart';

class LocationInput extends StatefulWidget {

  final Function _selectPlace;

  LocationInput(this._selectPlace);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;

  String _getMapImage(double lat, double lng) {
    return LocationHelper.generateLocationPreview(
        lat, lng);
  }

  Future<void> _getCurrentLocation() async {
    final locationData = await Location().getLocation();
    final previewUrl = _getMapImage(locationData.latitude, locationData.longitude);
    setState(() {
      _previewImageUrl = previewUrl;
    });
    widget._selectPlace(locationData.latitude, locationData.longitude);
  }

  Future<void> _selectOnMap() async {
    final LatLng selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => MapScreen(
          isSelecting: true,
        ),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    final previewUrl = _getMapImage(selectedLocation.latitude, selectedLocation.longitude);
    setState(() {
      _previewImageUrl = previewUrl;
    });
    widget._selectPlace(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: Center(
            child: _previewImageUrl == null
                ? Text(
                    'No Location Chosen',
                    textAlign: TextAlign.center,
                  )
                : Image.network(
                    _previewImageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FlatButton.icon(
              onPressed: _getCurrentLocation,
              icon: Icon(Icons.location_on),
              label: Text('Get Current Location'),
              textColor: Theme.of(context).primaryColor,
            ),
            FlatButton.icon(
              onPressed: _selectOnMap,
              icon: Icon(Icons.map),
              label: Text('Select On Map'),
              textColor: Theme.of(context).primaryColor,
            ),
          ],
        )
      ],
    );
  }
}
