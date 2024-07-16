import 'package:flutter/material.dart';

void main() {
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
//pantalla principal
class HomeScreen extends StatelessWidget {
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
              child: Text(
                'Bienvenido, gracias por usar nuestra app',
                style: TextStyle(fontSize: 24),
              ),
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GalleryScreen()),
                  );
                },
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
//pantalla secundaria
class GalleryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fotos'),
      ),
      body: Center(
        child: Text(
          //texto segunda pantalla
          'Galería',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
