import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:device_info/device_info.dart';
import 'package:path/path.dart';
import 'package:sensors/sensors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:battery/battery.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sqflite/sqflite.dart';

class PageB extends StatefulWidget {
  @override
  _PageBState createState() => _PageBState();
}

class _PageBState extends State<PageB> {
  String _manufacturer = '';
  String _model = '';
  String _buildNumber = '';
  String _sdkVersion = '';
  String _versionCode = '';
  int _refreshRate = 1;
  List<Map<String, dynamic>> _dataList = [];
  TextEditingController _textController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getDeviceInformation();
    _startAccelerometer();
  }

  void _getDeviceInformation() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context as BuildContext).platform == TargetPlatform.android) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      setState(() {
        _manufacturer = androidInfo.manufacturer;
        _model = androidInfo.model;
        _buildNumber = androidInfo.version.release;
        _sdkVersion = androidInfo.version.sdkInt.toString();
        _versionCode = androidInfo.version.codename;
      });
    } else if (Theme.of(context as BuildContext).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      setState(() {
        _model = iosInfo.model;
        _buildNumber = iosInfo.systemVersion;
      });
    }
  }

  void _startAccelerometer() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _refreshRate = (event.x.toInt() % 30) + 1;
      });
    });
  }

  void _saveData() async {
    String text = _textController.text.trim();
    String date = _dateController.text.trim();

    if (text.isNotEmpty && date.isNotEmpty) {
      Map<String, dynamic> data = {
        'text': text,
        'date': date,
      };

      // Simpan data ke database lokal
      await _insertData(data);

      // Bersihkan input field
      _textController.clear();
      _dateController.clear();

      // Perbarui tampilan data
      await _getDataList();
    }
  }

  void _deleteData(int id) async {
    await _deleteDataById(id);
    await _getDataList();
  }

  Future<void> _insertData(Map<String, dynamic> data) async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'data.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE data(id INTEGER PRIMARY KEY AUTOINCREMENT, text TEXT, date TEXT)',
        );
      },
      version: 1,
    );

    final db = await database;
    await db.insert(
      'data',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _getDataList() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'data.db'),
      version: 1,
    );

    final db = await database;
    final List<Map<String, dynamic>> dataList = await db.query('data');
    setState(() {
      _dataList = dataList;
    });
  }

  Future<void> _deleteDataById(int id) async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'data.db'),
      version: 1,
    );

    final db = await database;
    await db.delete(
      'data',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page B'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children:<Widget> [
          ListTile(
            title: Text(
              'Data SoC',
              style: TextStyle(fontSize: 18.0),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Manufacturer: $_manufacturer'),
                Text('Model: $_model'),
                Text('Build Number: $_buildNumber'),
                Text('SDK Version: $_sdkVersion'),
                Text('Version Code: $_versionCode'),
              ],
            ),
          ),
          ListTile(
            title: Text(
              'Update Refresh Rate',
              style: TextStyle(fontSize: 18.0),
            ),
            subtitle: Text(
              '$_refreshRate seconds',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          Divider(),
          ListTile(
            title: Text(
              'Input Text and Date',
              style: TextStyle(fontSize: 18.0),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    labelText: 'Text',
                  ),
                ),
                TextField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: 'Date',
                  ),
                ),
                ElevatedButton(
                  onPressed: _saveData,
                  child: Text('Save'),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Data List',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 8.0),
                FutureBuilder<void>(
                  future: _getDataList(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.connectionState == ConnectionState.done) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _dataList.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> data = _dataList[index];
                          int id = data['id'];
                          String text = data['text'];
                          String date = data['date'];

                          return ListTile(
                            title: Text(text),
                            subtitle: Text(date),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _deleteData(id),
                            ),
                          );
                        },
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              ],
            ),
          ),
          const Divider(),


        ],
      ),
    );
  }
}
