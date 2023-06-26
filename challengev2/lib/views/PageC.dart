import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:sensors/sensors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PageC extends StatefulWidget {
  @override
  _PageCState createState() => _PageCState();
}

class _PageCState extends State<PageC> {
  List<SensorValue> _accelerometerValues = [];
  List<SensorValue> _gyroscopeValues = [];
  List<SensorValue> _magnetometerValues = [];
  late LatLng _currentPosition;

  @override
  void initState() {
    super.initState();
    _startAccelerometer();
    _startGyroscope();
    _getCurrentLocation();
  }

  void _startAccelerometer() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerValues.add(SensorValue(DateTime.now(), event.x));
      });
    });
  }

  void _startGyroscope() {
    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscopeValues.add(SensorValue(DateTime.now(), event.x));
      });
    });
  }


  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page C'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Grafik Nilai Accelerometer',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 200.0,
              child: _accelerometerValues.isNotEmpty
                  ? charts.TimeSeriesChart(
                [
                  charts.Series<SensorValue, DateTime>(
                    id: 'Accelerometer',
                    colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
                    domainFn: (SensorValue value, _) => value.time,
                    measureFn: (SensorValue value, _) => value.value,
                    data: _accelerometerValues,
                  ),
                ],
                animate: true,
                dateTimeFactory: charts.LocalDateTimeFactory(),
              )
                  : Center(child: CircularProgressIndicator()),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Grafik Nilai Gyrometer',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 200.0,
              child: _gyroscopeValues.isNotEmpty
                  ? charts.TimeSeriesChart(
                [
                  charts.Series<SensorValue, DateTime>(
                    id: 'Gyrometer',
                    colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
                    domainFn: (SensorValue value, _) => value.time,
                    measureFn: (SensorValue value, _) => value.value,
                    data: _gyroscopeValues,
                  ),
                ],
                animate: true,
                dateTimeFactory: charts.LocalDateTimeFactory(),
              )
                  : Center(child: CircularProgressIndicator()),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Grafik Nilai Magnetometer',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 200.0,
              child: _magnetometerValues.isNotEmpty
                  ? charts.TimeSeriesChart(
                [
                  charts.Series<SensorValue, DateTime>(
                    id: 'Magnetometer',
                    colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
                    domainFn: (SensorValue value, _) => value.time,
                    measureFn: (SensorValue value, _) => value.value,
                    data: _magnetometerValues,
                  ),
                ],
                animate: true,
                dateTimeFactory: charts.LocalDateTimeFactory(),
              )
                  : Center(child: CircularProgressIndicator()),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Peta GPS',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 200.0,
              child: _currentPosition != null
                  ? GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _currentPosition,
                  zoom: 15.0,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId('currentLocation'),
                    position: _currentPosition,
                  ),
                },
              )
                  : Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}

class SensorValue {
  final DateTime time;
  final double value;

  SensorValue(this.time, this.value);
}
