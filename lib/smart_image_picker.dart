library smart_image_picker;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'bloc.dart';
import 'custom_loader_widget.dart';

class ImageSelector {
  String _positiveText;
  String _negativeText;
  String _message;
  final _picker = ImagePicker();


  /// Opens dialog to choose image from gallery or camera
  selectImage(BuildContext context, String positiveText, String negativeText,
      String message, Function(File) onSelect) async {
    _positiveText = positiveText;
    _negativeText = negativeText;
    _message = message;
    await showDialog(
      context: context,
      builder: (context) => ChangeNotifierProvider(
          create: (_) => UserBloc(),
          child: Consumer<UserBloc>(
            builder: (context, userBloc, child) {
              return CustomLoaderWidget(
                isTrue: userBloc.state == ViewState.Busy,
                child: new AlertDialog(
                  title: Text(message),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Divider(
                        color: Colors.grey[400],
                      ),
                      ListTile(
                        onTap: () async {
                          File selectedImage =
                          await _getImage(context, ImageSource.camera);
                          if (selectedImage != null) {
                            {
                              var result = await _showSelectedImageDialog(
                                  selectedImage, context);
                              if (result) {
                                userBloc.setState(ViewState.Busy);
                                await onSelect(selectedImage);
                              } else
                                Navigator.pop(context);
                            }
                          }
                        },
                        title: Text("Take Photo"),
                      ),
                      ListTile(
                        onTap: () async {
                          File selectedImage =
                          await _getImage(context, ImageSource.gallery);
                          if (selectedImage != null) {
                            var result = await _showSelectedImageDialog(
                                selectedImage, context);
                            if (result) {
                              userBloc.setState(ViewState.Busy);
                              await onSelect(selectedImage);
                            } else
                              Navigator.pop(context);
                          }
                        },
                        title: Text("Select from Gallery"),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    new FlatButton(
                        onPressed: () => Navigator.pop(context),
                        child: new Text(negativeText))
                  ],
                ),
              );
            },
          )),
    );
  }

  Future<File> _getImage(BuildContext context, ImageSource imgSrc) async {
    File _image;
    var image =
    await _picker.getImage(source: imgSrc, maxHeight: 480, maxWidth: 640);
    if (image != null) {
      _image = File(image.path);
    }
    return _image;
  }

  Future<bool> _showSelectedImageDialog(
      File _image, BuildContext context) async {
    imageCache.clear();
    var result = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => new AlertDialog(
        backgroundColor: Colors.white,
        title: Text(_message, style: TextStyle(color: Colors.black)),
        content: SingleChildScrollView(
          child: Container(
              width: 300.0,
              height: 300.0,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: FileImage(_image)
                  )
              )),
        ),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: new Text(
                _negativeText,
                style: TextStyle(color: Colors.black),
              )),
          FlatButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: new Text(
                _positiveText,
                style: TextStyle(color: Colors.black),
              ))
        ],
      ),
    );
    return result;
  }
}
