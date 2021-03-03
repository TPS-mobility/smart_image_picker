import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:smart_image_picker/smart_image_picker.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Uint8List image;
  void _loadImage() {
    ImageSelector().selectImage(context,"Upload", "Cancel", "Upload Image", (selectedImage) async {
      await Future.delayed(Duration(seconds: 10));
      setState(() {
      image = selectedImage?.readAsBytesSync();
            });
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (image!=null)
            Image.memory(image),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadImage,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
