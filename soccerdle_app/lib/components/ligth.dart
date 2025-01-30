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
  int lux = 0;
  String message = '';
  String ledState = 'off'; // Default LED state

  final String baseUrl = 'https://sd-group1-7db20f01361c.herokuapp.com';

  @override
  void initState() {
    super.initState();
    fetchLuxData();
    fetchLedState();
  }

  Future<void> fetchLuxData() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/unlimited/collectlux'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'lux': -1}),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        setState(() {
          lux = data['user']['lux'] ?? 0;
          message = '';
        });
      } else {
        setState(() {
          message = 'Failed to fetch lux data. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        message = 'Error occurred: ${e.toString()}';
      });
    }
  }

  Future<void> fetchLedState() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/unlimited/updateLedState'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          ledState = data['ledState'] ?? 'off';
        });
      } else {
        setState(() {
          message = 'Failed to fetch LED state.';
        });
      }
    } catch (e) {
      setState(() {
        message = 'Error occurred while fetching LED state: ${e.toString()}';
      });
    }
  }

  Future<void> toggleLed() async {
    try {
      String newState = ledState == 'on' ? 'off' : 'on';

      final response = await http.post(
        Uri.parse('$baseUrl/api/unlimited/led'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'ledState': newState}),
      );

      if (response.statusCode == 201) {
        setState(() {
          ledState = newState;
        });
      } else {
        setState(() {
          message = 'Failed to update LED state.';
        });
      }
    } catch (e) {
      setState(() {
        message = 'Error occurred while updating LED state: ${e.toString()}';
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
                          'Lux Value',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '$lux',
                          style: const TextStyle(
                            fontSize: 60,
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
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  onPressed: fetchLuxData,
                  child: const Text(
                    'Refresh',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ledState == 'on' ? Colors.green : Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  onPressed: toggleLed,
                  child: Text(
                    ledState == 'on' ? 'Turn LED Off' : 'Turn LED On',
                    style: const TextStyle(
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
