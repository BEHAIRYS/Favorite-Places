import 'dart:convert';

import 'package:fav_places/Model/place-location.dart';
import 'package:fav_places/Model/place.dart';
import 'package:fav_places/Screen/map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class PlaceDetails extends StatefulWidget {
  final Place place;
  const PlaceDetails({required this.place});

  @override
  State<PlaceDetails> createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends State<PlaceDetails> {
  LatLng? _location;
  get address async {
    final uri = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${_location!.latitude},${_location!.longitude}&key=AIzaSyC3GmcPu_IqktgOn9FLloSXHA69CjUzIh8');
    final response = await http.get(uri);
    final resBody = json.decode(response.body);
    final address = resBody['results'][0]['formatted_address'];
    return address;
  }

  _updatePlace() async {
    String _address = await address;
    setState(() {
      widget.place.location = PlaceLocation(
          address: _address,
          latitude: _location!.latitude,
          longitude: _location!.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.place.title),
      ),
      body: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.hardEdge,
        children: [
          Image.file(widget.place.image, fit: BoxFit.fitHeight),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    _location = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const MapScreen();
                        },
                      ),
                    );
                    _updatePlace();
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://maps.googleapis.com/maps/api/staticmap?center=${widget.place.location.latitude},${widget.place.location.longitude}=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C${widget.place.location.latitude},${widget.place.location.longitude}&key=AIzaSyC3GmcPu_IqktgOn9FLloSXHA69CjUzIh8'),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black45,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        widget.place.title,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        widget.place.location.address,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                              fontSize: 12,
                            ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
