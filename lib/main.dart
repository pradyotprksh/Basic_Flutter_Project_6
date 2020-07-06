import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:native_device_feature/providers/great_places.dart';
import 'package:native_device_feature/screen/place_list_screen.dart';
import 'package:native_device_feature/screen/add_place_screen.dart';
import 'package:native_device_feature/screen/map_screen.dart';
import 'package:native_device_feature/screen/place_detail_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: GreatPlaces(),
      child: MaterialApp(
        title: 'Great Places',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          accentColor: Colors.amber,
        ),
        home: PlaceListScreen(),
        routes: {
          AddPlaceScreen.routeName: (ctx) => AddPlaceScreen(),
          MapScreen.routeName: (ctx) => MapScreen(),
          PlaceDetailScreen.routeName: (ctx) => PlaceDetailScreen(),
        },
      ),
    );
  }
}
