import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  final Function onSelectedImage;

  ImageInput(this.onSelectedImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;

  Future<void> _takePicture() async {
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    // We need to check is imageFile have data after take image.
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = imageFile;
    });
    // getApplicationDocumentsDirectory is a directory which is reserve for app data in the devices.
    final appDir = await syspaths.getApplicationDocumentsDirectory();

    // to get file name from appDir.
    final fileName = path.basename(imageFile.path);

    // copy is use to copy this file to new Location.
    // we need to access path from appDir where our image store using "appDir.path".
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');

    //widget is global property. giving the access of widget class.
    // sending savedImage path to "AddPlaceScreen";
    widget.onSelectedImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _storedImage != null
              ? Image.file(
                  _storedImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  'No Image Taken',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: FlatButton.icon(
            icon: Icon(Icons.camera),
            label: Text('Take Picture'),
            textColor: Theme.of(context).primaryColor,
            onPressed: _takePicture,
          ),
        ),
      ],
    );
  }
}
