import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:synapsis_project/views/utils/device_info.dart';
import 'package:synapsis_project/views/utils/geolocation.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  final _battery = Battery();
  DateTime today = DateTime.now();
  String date = '';
  String timeNow = '';
  List<double>? _accelerometerValues;
  List<double>? _userAccelerometerValues;
  List<double>? _gyroscopeValues;
  List<double>? _magnetometerValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  var location = '';
  late Timer timer;
  int _batteryLevel = 0;

  String formatDateTime(DateTime time) {
    return DateFormat('hh:mm:ss').format(time);
  }

  void _getTime() {
    DateTime now = DateTime.now();
    String formattedTime = formatDateTime(now);
    setState(() {
      timeNow = formattedTime;
    });
  }

  getDateTimeNow() {
    setState(() {
      date = "${today.day}-${today.month}-${today.year}";
      timeNow = formatDateTime(DateTime.now());
      timer =
          Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
    });
  }

  sensorsAcc() {
    _streamSubscriptions.add(
      userAccelerometerEvents.listen(
        (UserAccelerometerEvent event) {
          setState(() {
            _userAccelerometerValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
    _streamSubscriptions.add(
      accelerometerEvents.listen(
        (AccelerometerEvent event) {
          setState(() {
            _accelerometerValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
  }

  sensorsGyro() {
    _streamSubscriptions.add(
      gyroscopeEvents.listen(
        (GyroscopeEvent event) {
          setState(() {
            _gyroscopeValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
  }

  sensorsMagnet() {
    _streamSubscriptions.add(
      magnetometerEvents.listen(
        (MagnetometerEvent event) {
          setState(() {
            _magnetometerValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
  }

  @override
  void initState() {
    sensorsAcc();
    sensorsMagnet();
    sensorsGyro();
    getDateTimeNow();
    getBatteryLevel();
    initPlatformState();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  void getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // var lastPosition = await Geolocator.getLastKnownPosition();
    setState(() {
      location = "Lat: ${position.latitude}, Long: ${position.longitude}";
    });
  }

  void getBatteryLevel() async {
    var batteryLevel = await _battery.batteryLevel;
    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    final accelerometer =
        _accelerometerValues?.map((double v) => v.toStringAsFixed(1)).toList();
    final userAccelerometer = _userAccelerometerValues
        ?.map((double v) => v.toStringAsFixed(1))
        .toList();
    final gyroscope =
        _gyroscopeValues?.map((double v) => v.toStringAsFixed(1)).toList();
    final magnetometer =
        _magnetometerValues?.map((double v) => v.toStringAsFixed(1)).toList();
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Text(
                'Welcome !',
                style: GoogleFonts.poppins(fontSize: 40),
              ),
              Text('Today date: $date'),
              Text('Time: $timeNow'),
              const SizedBox(
                height: 50,
              ),
              // add shared prefs get fullname,
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Accelerometer: $accelerometer'),
                      Text('User Accelerometer: $userAccelerometer'),
                      Text('Gyroscope: $gyroscope'),
                      Text('Magnetometer: $magnetometer'),
                      Text('Hardware Info: ${_deviceData['hardware']}'),
                      Text('Your battery level: $_batteryLevel'),
                      const SizedBox(
                        height: 20,
                      ),
                      // gLocation(location, getCurrentLocation),
                      const SizedBox(
                        height: 20,
                      ),
                      myLocation(context, location, getCurrentLocation),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
