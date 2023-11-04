import 'package:fav_places/Model/place-location.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  final void Function(PlaceLocation location) onSelectLocation;
  const LocationInput({super.key, required this.onSelectLocation});

  @override
  State<StatefulWidget> createState() {
    return LocationInput_State();
  }
}

class LocationInput_State extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;
  String get locationImage {
    if (_pickedLocation == null) {
      return '';
    }
    final lat = _pickedLocation!.latitude;
    final lng = _pickedLocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=AIzaSyC3GmcPu_IqktgOn9FLloSXHA69CjUzIh8';
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'No location chosen',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
    );

    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }
    if (_pickedLocation != null) {
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text('Get Current Location'),
              onPressed: _getLocation,
            ),
            TextButton.icon(
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  _getLocation() async {
    Location location = new Location();
    final latitude, longitude;

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();

    setState(() {
      _isGettingLocation = false;
    });
    latitude = locationData.latitude;
    longitude = locationData.longitude;
    final uri = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=AIzaSyC3GmcPu_IqktgOn9FLloSXHA69CjUzIh8');
    final response = await http.get(uri);
    final resBody = json.decode(response.body);
    final address = resBody['results'][0]['formatted_address'];
    setState(() {
      _pickedLocation = PlaceLocation(
          address: address, latitude: latitude, longitude: longitude);
      _isGettingLocation = false;
    });
    widget.onSelectLocation(_pickedLocation!);
  }
}
