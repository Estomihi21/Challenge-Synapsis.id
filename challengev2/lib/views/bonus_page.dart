import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors/sensors.dart';
import 'package:image/image.dart' as img;

/*class BonusPage extends StatefulWidget {
  @override
  _BonusPageState createState() => _BonusPageState();
}

class _BonusPageState extends State<BonusPage> {
  late CameraController _cameraController;
  late List<CameraDescription> _availableCameras;
  late Position _currentPosition;
  late double _magnetoValue;

  @override
  void initState() {
    super.initState();

    _initializeCamera();
    _getCurrentLocation();
    _startMagnetoStream();
  }

  void _initializeCamera() async {
    _availableCameras = await availableCameras();
    _cameraController = CameraController(_availableCameras[0], ResolutionPreset.medium);
    await _cameraController.initialize();
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
    });
  }

  void _startMagnetoStream() {
    magnetometerEvents.listen((MagnetometerEvent event) {
      setState(() {
        _magnetoValue = event.z;
      });
    });
  }

  void _takePicture() async {
    XFile picture = await _cameraController.takePicture();

    String imagePath = picture.path;
    await addTextToImage(
      imagePath,
      text: DateTime.now().toString(),
      position: Offset(10, 10),
      color: Colors.white,
      fontSize: 24,
    );
    await addTextToImage(
      imagePath,
      text: 'Geolocation: ${_currentPosition?.latitude ?? ''}, ${_currentPosition?.longitude ?? ''}',
      position: Offset(10, 40),
      color: Colors.white,
      fontSize: 24,
    );
    await addTextToImage(
      imagePath,
      text: 'Magneto Value: ${_magnetoValue ?? ''}',
      position: Offset(10, 70),
      color: Colors.white,
      fontSize: 24,
    );

  }

  Future<void> addTextToImage(String imagePath, {required String text, Offset position, Color color, double fontSize}) async {
    img.Image? image = img.decodeImage(File(imagePath).readAsBytesSync());
    img.drawString(
      image,
      img.arial_24,
      position.dx.toInt(),
      position.dy.toInt(),
      text,
      color: color.value, font: null,
    );
    Uint8List bytes = img.encodeJpg(image);
    await File(imagePath).writeAsBytes(bytes);
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bonus Page')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: _cameraController.value.aspectRatio,
              child: CameraPreview(_cameraController),
            ),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _takePicture,
            child: Text('Take Picture'),
          ),
        ],
      ),
    );
  }
}
*/