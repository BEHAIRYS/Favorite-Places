import 'package:fav_places/Model/place.dart';
import 'package:fav_places/Provider/UserPlaceProvider.dart';
import 'package:fav_places/Screen/Place-detail.dart';
import 'package:fav_places/Screen/map.dart';
import 'package:fav_places/Widget/add-Place.dart';
import 'package:fav_places/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesList extends ConsumerWidget {
  PlacesList({super.key, required this.places});
  final List<Place> places;
  Widget content = Container(
    alignment: Alignment.center,
    child: const Text(
      'No Entered Places Yet!',
    ),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Place> _placesList = ref.watch(userPlaceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) {
                    return AddPlace();
                  },
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _placesList.isEmpty
          ? content
          : ListView.builder(
              itemCount: _placesList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: ListTile(
                    title: Text(_placesList[index].title),
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return PlaceDetails(place: _placesList[index]);
                    }));
                  },
                );
              },
            ),
    );
  }
}
