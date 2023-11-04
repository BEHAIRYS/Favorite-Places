import 'dart:io';

import 'package:fav_places/Model/place-location.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class Place {
  Place(
      {required this.location,
      required this.image,
      required this.title,
      String? id})
      : id = id ?? uuid.v4();

  final String title;
  final String id;
  final File image;
  PlaceLocation location;
}
