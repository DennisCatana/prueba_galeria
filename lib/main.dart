import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
  bool _isLoading = false;

  Future<void> _takePhoto() async {
    XFile? photo;
    if (kIsWeb) {
      photo = await _picker.pickImage(source: ImageSource.camera);
    } else {
      photo = await _picker.pickImage(source: ImageSource.camera);
    }

    if (photo != null) {
      final bytes = await photo.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  Future<void> _uploadPhoto() async {
    if (_imageBytes == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Subir la imagen a Firebase Storage
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef =
          FirebaseStorage.instance.ref().child('photos/$fileName');
      UploadTask uploadTask = storageRef.putData(_imageBytes!);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        _imageBytes = null;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Foto subida exitosamente')),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al subir la foto: $e')),
      );
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
          if (_imageBytes != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ElevatedButton(
                onPressed: _uploadPhoto,
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text('Guardar en Firebase'),
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
