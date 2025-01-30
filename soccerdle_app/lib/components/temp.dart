import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SensorDataDisplayPage extends StatefulWidget {
  static const String routeName = '/sensorDataDisplay';
  const SensorDataDisplayPage({Key? key}) : super(key: key);

  @override
  _SensorDataDisplayPageState createState() => _SensorDataDisplayPageState();
}

class _SensorDataDisplayPageState extends State<SensorDataDisplayPage> {
  int co2 = 0;
  double temperature = 0.0;
  double humidity = 0.0;
  String message = '';

  final String baseUrl = 'https://sd-group1-7db20f01361c.herokuapp.com';

  @override
  void initState() {
    super.initState();
    fetchSensorData();
  }

Future<void> fetchSensorData() async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/api/unlimited/collectSensorData'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({}), // Fetch stored data
    );

    print('HTTP Response code: ${response.statusCode}');
    print('Response from server: ${response.body}');

    if (response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      // Accessing sensor values inside 'user'
      final Map<String, dynamic>? user = data['user'];

      if (user != null) {
        setState(() {
          co2 = user['co2']?.toInt() ?? 0;
          temperature = (user['temperature'] as num?)?.toDouble() ?? 0.0;
          humidity = (user['humidity'] as num?)?.toDouble() ?? 0.0;
          message = ''; // Clear error message
        });

        print('Parsed values -> CO2: $co2, Temperature: $temperature, Humidity: $humidity');
      } else {
        setState(() {
          message = 'No user data found';
        });
      }
    } else {
      setState(() {
        message = 'Failed to fetch sensor data. Status: ${response.statusCode}';
      });
    }
  } catch (e) {
    setState(() {
      message = 'Error: ${e.toString()}';
    });
  }
}




  Widget _buildBackgroundImage() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/images/app.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sensor Data',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          _buildBackgroundImage(), // Background image
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (message.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (message.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'CO2 Level',
                          style: TextStyle(
                            fontSize: 40, // Larger "CO2 Level" text
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '$co2 ppm',
                          style: const TextStyle(
                            fontSize: 60, // Larger CO2 number
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Temperature',
                          style: TextStyle(
                            fontSize: 40, // Larger "Temperature" text
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '$temperature °C',
                          style: const TextStyle(
                            fontSize: 60, // Larger temperature number
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Humidity',
                          style: TextStyle(
                            fontSize: 40, // Larger "Humidity" text
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '$humidity %',
                          style: const TextStyle(
                            fontSize: 60, // Larger humidity number
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Button background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10), // Smaller button
                  ),
                  onPressed: () async {
                    await fetchSensorData();
                  },
                  child: const Text(
                    'Refresh',
                    style: TextStyle(
                      fontSize: 16, // Standard text size for button
                      color: Colors.white, // White text color
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}