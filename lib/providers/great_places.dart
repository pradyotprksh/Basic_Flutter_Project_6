import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:native_device_feature/helpers/db_helper.dart';
import 'package:native_device_feature/helpers/location_helper.dart';
import 'package:native_device_feature/modals/place.dart';

class GreatPlaces extends ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Place findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> addPlace(String pickedTitle, File pickedImage,
      PlaceLocation pickedLocation) async {
    final address = await LocationHelper.getPlaceAddress(
        pickedLocation.latitude, pickedLocation.longitude);
    final updatedLocation = PlaceLocation(
        latitude: pickedLocation.latitude,
        longitude: pickedLocation.longitude,
        address: address);
    final newPlace = Place(
      id: DateTime.now().toString(),
      title: pickedTitle,
      image: pickedImage,
      location: updatedLocation,
    );
    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': updatedLocation.latitude,
      'loc_lng': updatedLocation.longitude,
      'address': updatedLocation.address,
    });
  }

  Future<void> getPlaces() async {
    final dataList = await DBHelper.get('user_places');
    _items = dataList
        .map(
          (e) => Place(
            id: e['id'],
            title: e['title'],
            image: File(e['image']),
            location: PlaceLocation(
                latitude: e['loc_lat'],
                longitude: e['loc_lng'],
                address: e['address']),
          ),
        )
        .toList();
    notifyListeners();
  }
}
