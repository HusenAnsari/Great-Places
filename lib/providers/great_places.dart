import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:greatplaces/helpers/db_helper.dart';

import '../models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Place findById(String id) {
    return _items.firstWhere((place) => place.id == id);
  }

  void addPlace(String pickedTitle, File pickedImage) {
    final newPlace = Place(
      id: DateTime.now().toString(),
      title: pickedTitle,
      location: null,
      image: pickedImage,
    );
    _items.add(newPlace);
    // Key in map need to match with db_helper class.
    // same name of table which we create in DbHelper page.
    DbHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      // we need to use .path as we storing image path in database.
      'image': newPlace.image.path,
    });
    notifyListeners();
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DbHelper.getData('user_places');
    // using .map we can transfer all element in different element.
    // in map we can get all data from dataList ".map((items) =>"
    _items = dataList
        .map(
          (items) => Place(
            id: items['id'],
            title: items['title'],
            // we need file to get image so we use File to convert path to file.
            // File(items['image']) will create a new file base on "items['image']" path.
            image: File(items['image']),
            location: null,
          ),
        )
        .toList();
    notifyListeners();
  }
}
