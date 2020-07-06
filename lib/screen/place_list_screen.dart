import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:native_device_feature/providers/great_places.dart';
import 'package:native_device_feature/screen/add_place_screen.dart';
import 'package:native_device_feature/screen/place_detail_screen.dart';

class PlaceListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Places'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false).getPlaces(),
        builder: (futureContext, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<GreatPlaces>(
                child: Center(
                  child: Text('Got No Place Added.'),
                ),
                builder: (consumeContext, greatPlaces, child) =>
                    greatPlaces.items.length <= 0
                        ? child
                        : ListView.builder(
                            itemCount: greatPlaces.items.length,
                            itemBuilder: (listContext, position) => ListTile(
                              leading: CircleAvatar(
                                backgroundImage: FileImage(
                                    greatPlaces.items[position].image),
                              ),
                              title: Text(greatPlaces.items[position].title),
                              subtitle: Text(
                                greatPlaces.items[position].location.address,
                              ),
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  PlaceDetailScreen.routeName,
                                  arguments: greatPlaces.items[position].id,
                                );
                              },
                            ),
                          ),
              ),
      ),
    );
  }
}
