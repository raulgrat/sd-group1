import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LuxDisplayPage extends StatefulWidget {
  static const String routeName = '/luxDisplay';
  const LuxDisplayPage({Key? key}) : super(key: key);

  @override
  _LuxDisplayPageState createState() => _LuxDisplayPageState();
}

class _LuxDisplayPageState extends State<LuxDisplayPage> {
  int lux0 = 0; // White light
  int lux1 = 0; // Red light
  int lux2 = 0; // Blue light
  String message = '';

  final String baseUrl = 'https://sd-group1-7db20f01361c.herokuapp.com';

  double get blueRedRatio => lux1 == 0 ? 0 : lux2 / lux1; // Avoid division by zero

  @override
  void initState() {
    super.initState();
    fetchLuxData();
  }

  Future<void> fetchLuxData() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/unlimited/collectlux'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({}),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final Map<String, dynamic>? user = data['user'];
        if (user != null) {
          setState(() {
            lux0 = user['lux0']?.toInt() ?? 0;
            lux1 = user['lux1']?.toInt() ?? 0;
            lux2 = user['lux2']?.toInt() ?? 0;
            message = '';
          });
        }
      } else {
        setState(() {
          message = 'Failed to fetch lux data. Status code: ${response.statusCode}.';
        });
      }
    } catch (e) {
      setState(() {
        message = 'Error occurred: ${e.toString()}';
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
                        const Text(
                          'Ambient Light',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                const Icon(Icons.lightbulb, size: 40, color: Color.fromARGB(255, 240, 250, 49)),
                                const SizedBox(height: 5),
                                Text(
                                  'White: $lux0',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Icon(Icons.lightbulb, size: 40, color: Colors.red),
                                const SizedBox(height: 5),
                                Text(
                                  'Red: $lux1',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Icon(Icons.lightbulb, size: 40, color: Colors.blue),
                                const SizedBox(height: 5),
                                Text(
                                  'Blue: $lux2',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Blue to Red Ratio: ',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              blueRedRatio.toStringAsFixed(2),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: blueRedRatio > 1 ? Colors.blue : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: fetchLuxData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Rounded button
                    ),
                    elevation: 5, // Shadow effect
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
