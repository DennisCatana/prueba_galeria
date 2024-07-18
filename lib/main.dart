import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyCameraApp());
}

class MyCameraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      final bytes = await photo.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: _imageBytes == null
                  ? Text(
                      'Bienvenido, gracias por usar nuestra app',
                      style: TextStyle(fontSize: 24),
                    )
                  : Image.memory(_imageBytes!),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(24),
                ),
                onPressed: _takePhoto,
                child: Icon(
                  Icons.camera_alt,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
