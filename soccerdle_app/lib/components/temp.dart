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
  bool isCelsius = true;

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
        body: jsonEncode({}),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final Map<String, dynamic>? user = data['user'];

        if (user != null) {
          setState(() {
            co2 = user['co2']?.toInt() ?? 0;
            temperature = (user['temperature'] as num?)?.toDouble() ?? 0.0;
            humidity = (user['humidity'] as num?)?.toDouble() ?? 0.0;
            message = '';
          });
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
    double displayedTemperature = isCelsius ? temperature : (temperature * 9 / 5) + 32;
    String temperatureUnit = isCelsius ? '°C' : '°F';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'G.E.A',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          _buildBackgroundImage(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (message.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
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
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: Colors.black, // Set the border color
                          width: 1.5, // Set the border width
                        ),
                      ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'CO₂ ',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '$co2 ppm',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: co2 > 1000 ? Colors.red : Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                const Icon(Icons.thermostat, size: 40),
                                const SizedBox(height: 5),
                                Text(
                                  '${displayedTemperature.toStringAsFixed(1)} $temperatureUnit',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Icon(Icons.water_drop, size: 40),
                                const SizedBox(height: 5),
                                Text(
                                  '$humidity %',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        DropdownButton<bool>(
                          value: isCelsius,
                          items: const [
                            DropdownMenuItem(value: true, child: Text('Celsius (°C)')),
                            DropdownMenuItem(value: false, child: Text('Fahrenheit (°F)')),
                          ],
                          onChanged: (bool? newValue) {
                            if (newValue != null) {
                              setState(() {
                                isCelsius = newValue;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: fetchSensorData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Background color
                    side: const BorderSide(color: Colors.black, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Rounded button 
                    ),
                    
                    elevation: 1, // Shadow effect
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.refresh,
                        color: Colors.green, // Icon color
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Refresh',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black, // Text color
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
