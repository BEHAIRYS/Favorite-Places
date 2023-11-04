import 'dart:io';

import 'package:fav_places/Model/place-location.dart';
import 'package:fav_places/Model/place.dart';
import 'package:fav_places/Provider/UserPlaceProvider.dart';
import 'package:fav_places/Widget/Image-input.dart';
import 'package:fav_places/Widget/location-input.dart';
import 'package:fav_places/main.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlace extends ConsumerStatefulWidget {
  @override
  ConsumerState<AddPlace> createState() {
    return _AddPlaceState();
  }
}

class _AddPlaceState extends ConsumerState<AddPlace> {
  final TextEditingController _TextController = TextEditingController();
  PlaceLocation? _placeLocation;
  File? _pickedImage;
  void _addPlace(String title) {
    if (title.isEmpty) {
      return;
    }
    if (_placeLocation == null) {
      return;
    }
    Place newPlace =
        Place(title: title, image: _pickedImage!, location: _placeLocation!);
    ref.read(userPlaceProvider.notifier).addPlace(newPlace);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _TextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Place'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(children: [
            TextField(
              controller: _TextController,
              decoration: const InputDecoration(
                label: Text('Title'),
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            ImageInput(
              onSelectImage: (File image) {
                _pickedImage = image;
              },
            ),
            const SizedBox(
              height: 18,
            ),
            LocationInput(
              onSelectLocation: (PlaceLocation location) {
                _placeLocation = location;
              },
            ),
            ElevatedButton.icon(
                onPressed: () {
                  _addPlace(_TextController.text);
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Place'))
          ]),
        ),
      ),
    );
  }
}
