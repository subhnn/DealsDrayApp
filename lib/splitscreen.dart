import 'dart:async';
import 'dart:convert'; // For JSON encoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'homepage.dart'; // Ensure the correct import for your homepage

class Splitscreen extends StatefulWidget {
  const Splitscreen({super.key});

  @override
  State<Splitscreen> createState() => _SplitscreenState();
}

class _SplitscreenState extends State<Splitscreen> {
  @override
  void initState() {
    super.initState();
    _registerDevice(); // Call the device registration method
  }

  // Device registration method
  Future<void> _registerDevice() async {
    final url = 'http://devapiv4.dealsdray.com/api/v2/user/device/add';
    final deviceId = 'C6179909526098'; // Replace with actual device ID
    final deviceName = 'Samsung-MT200'; // Replace with actual device name
    final deviceOSVersion = '2.3.6'; // Replace with actual device OS version
    final deviceIPAddress = '192.168.1.5'; // Replace with actual IP address
    final latitude = 9.9312; // Replace with actual latitude
    final longitude = 76.2673; // Replace with actual longitude
    final appVersion = '1.20.5'; // Replace with actual app version
    final installTimestamp = DateTime.now().toIso8601String(); // Install time

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "deviceType": "android",
          "deviceId": deviceId,
          "deviceName": deviceName,
          "deviceOSVersion": deviceOSVersion,
          "deviceIPAddress": deviceIPAddress,
          "lat": latitude,
          "long": longitude,
          "buyer_gcmid": "",
          "buyer_pemid": "",
          "app": {
            "version": appVersion,
            "installTimeStamp": installTimestamp,
            "uninstallTimeStamp": installTimestamp,
            "downloadTimeStamp": installTimestamp,
          },
        }),
      );

      // If registration is successful, navigate to Home page after 3 seconds
      if (response.statusCode == 200) {
        print('Device registered successfully');
      } else {
        print('Device registration failed: ${response.body}');
      }

      // Navigate to Home screen regardless of registration outcome
      Timer(Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()), // Navigate to Home
        );
      });
    } catch (e) {
      print('An error occurred: $e');
      // Handle any errors and navigate to Home anyway
      Timer(Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Image.asset(
                  "assets/images/delasdray.png",
                  height: 400.0,
                  width: 300.0,
                  alignment: Alignment.bottomCenter,
                  fit: BoxFit.contain,
                ),
                Text(
                  "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
            CircularProgressIndicator(
              valueColor:  AlwaysStoppedAnimation<Color>(Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
