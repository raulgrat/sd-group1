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
  int lux0 = 0;
  int lux1 = 0;
  int lux2 = 0;
  String message = '';

  final String baseUrl = 'https://sd-group1-7db20f01361c.herokuapp.com';

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
        body: jsonEncode({}), // Sending data to request lux values
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final Map<String, dynamic>? user = data['user'];
        if (user != null) {
        setState(() {
          lux0 = user['lux0']?.toInt() ?? 0;
          lux1 = user['lux1']?.toInt() ?? 0;
          lux2 = user['lux2']?.toInt() ?? 0;
          message = ''; // Clear any previous error message
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
          'Lux Data',
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
                          'Lux Values',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Lux0: $lux0',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Lux1: $lux1',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Lux2: $lux2',
                          style: const TextStyle(
                            fontSize: 24,
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
                    backgroundColor: Colors.blue, 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10), 
                  ),
                  onPressed: () async {
                    await fetchLuxData();
                  },
                  child: const Text(
                    'Refresh',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
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
