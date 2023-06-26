import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sensors/sensors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:battery/battery.dart';

class PageA extends StatefulWidget {
  final String appBarTitle;

  PageA({required this.appBarTitle});

  @override
  _PageAState createState() => _PageAState();
}

class _PageAState extends State<PageA> {
  String _currentTime = '';
  String _currentDate = '';
  String _accelerometerInfo = '';
  String _gyroscopeInfo = '';
  String _gpsCoordinate = '';
  String _batteryLevel = '';

  @override
  void initState() {
    super.initState();
    _getCurrentTime();
    _getCurrentDate();
    _startAccelerometer();
    _startGyroscope();
    _getCurrentLocation();
    _getBatteryLevel();
  }

  void _getCurrentTime() {
    setState(() {
      _currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
    });
  }

  void _getCurrentDate() {
    setState(() {
      _currentDate = DateFormat('dd MMMM yyyy').format(DateTime.now());
    });
  }

  void _startAccelerometer() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerInfo =
        'X: ${event.x.toStringAsFixed(2)}, Y: ${event.y.toStringAsFixed(2)}, Z: ${event.z.toStringAsFixed(2)}';
      });
    });
  }

  void _startGyroscope() {
    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscopeInfo =
        'X: ${event.x.toStringAsFixed(2)}, Y: ${event.y.toStringAsFixed(2)}, Z: ${event.z.toStringAsFixed(2)}';
      });
    });
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _gpsCoordinate =
      'Latitude: ${position.latitude.toStringAsFixed(6)}, Longitude: ${position.longitude.toStringAsFixed(6)}';
    });
  }

  void _getBatteryLevel() async {
    Battery battery = Battery();
    int batteryLevel = await battery.batteryLevel;
    setState(() {
      _batteryLevel = '$batteryLevel%';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarTitle),

      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: Text(
              'Waktu saat ini',
              style: TextStyle(fontSize: 18.0),
            ),
            subtitle: Text(
              _currentTime,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: Text(
              'Tanggal saat ini',
              style: TextStyle(fontSize: 18.0),
            ),
            subtitle: Text(
              _currentDate,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              'Accelerometer Sensor',
              style: TextStyle(fontSize: 18.0),
            ),
            subtitle: Text(
              _accelerometerInfo,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            title: Text(
              'Gyroscope Sensor',
              style: TextStyle(fontSize: 18.0),
            ),
            subtitle: Text(
              _gyroscopeInfo,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              'GPS Coordinate',
              style: TextStyle(fontSize: 18.0),
            ),
            subtitle: Text(
              _gpsCoordinate,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            title: Text(
              'Battery Level',
              style: TextStyle(fontSize: 18.0),
            ),
            subtitle: Text(
              _batteryLevel,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }
}
