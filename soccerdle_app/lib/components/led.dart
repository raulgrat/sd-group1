import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LEDBulbControlPage extends StatefulWidget {
  const LEDBulbControlPage({Key? key}) : super(key: key);

  @override
  _LEDBulbControlPageState createState() => _LEDBulbControlPageState();
}

class _LEDBulbControlPageState extends State<LEDBulbControlPage> {
  // List to track the on/off state for 20 LEDs (all initially off).
  final List<bool> ledStates = List<bool>.filled(20, false);

  // Heroku server URL endpoint for LED control.
  final String ledControlUrl =
      'https://sd-group1-7db20f01361c.herokuapp.com/api/unlimited/ledcontrol';

  // Returns the color for each LED bulb: gray if off, blue for first 10 when on, red for last 10.
  Color _getLEDBulbColor(int index) {
    return !ledStates[index]
        ? Colors.grey
        : index < 10
            ? const Color.fromARGB(255, 3, 85, 152) // Blue for first 10
            : const Color.fromARGB(255, 176, 19, 8); // Red for last 10
  }

  // Background image.
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

  // Function to set the LED states for different modes.
  void _setPresetMode(int blueOn, int redOn) {
    setState(() {
      for (int i = 0; i < ledStates.length; i++) {
        if (i < 10) {
          // First 10 bulbs (blue)
          ledStates[i] = i < blueOn;
        } else {
          // Last 10 bulbs (red)
          ledStates[i] = (i - 10) < redOn;
        }
      }
    });
    _updateLEDStates(); // Send update after mode change.
  }

  // Function to send the current LED states to your Heroku server.
  Future<void> _updateLEDStates() async {
    try {
      final response = await http.post(
        Uri.parse(ledControlUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'ledStates': ledStates}),
      );
      if (response.statusCode == 200) {
        print("LED states updated successfully");
        print("Server Response: ${response.body}");
      } else {
        print("Failed to update LED states: ${response.statusCode}");
      }
    } catch (e) {
      print("Error updating LED states: $e");
    }
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
          Column(
            children: [
              Expanded(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black, width: 1.5),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'LED Control',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // ----------------------------------------------------------------
                        // Manually build rows to match the physical 6/4/6/4 LED layout
                        // ----------------------------------------------------------------
                        // Row 1 (blue): indices 0..5
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(6, (i) {
                            final index = i; // 0..5
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  ledStates[index] = !ledStates[index];
                                });
                                _updateLEDStates();
                              },
                              child: Icon(
                                Icons.lightbulb,
                                size: 50,
                                color: _getLEDBulbColor(index),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 20),

                        // Row 2 (blue): indices 6..9
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(4, (i) {
                            final index = i + 6; // 6..9
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  ledStates[index] = !ledStates[index];
                                });
                                _updateLEDStates();
                              },
                              child: Icon(
                                Icons.lightbulb,
                                size: 50,
                                color: _getLEDBulbColor(index),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 40), // bigger gap before red

                        // Row 3 (red): indices 10..15
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(6, (i) {
                            final index = i + 10; // 10..15
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  ledStates[index] = !ledStates[index];
                                });
                                _updateLEDStates();
                              },
                              child: Icon(
                                Icons.lightbulb,
                                size: 50,
                                color: _getLEDBulbColor(index),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 20),

                        // Row 4 (red): indices 16..19
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(4, (i) {
                            final index = i + 16; // 16..19
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  ledStates[index] = !ledStates[index];
                                });
                                _updateLEDStates();
                              },
                              child: Icon(
                                Icons.lightbulb,
                                size: 50,
                                color: _getLEDBulbColor(index),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 1),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  _buildPresetButton('All On', 10, 10),
                  _buildPresetButton('All Off', 0, 0),
                  _buildPresetButton('50-50', 5, 5),
                  _buildPresetButton('20-80', 2, 8),
                  _buildPresetButton('70-30', 7, 3),
                  _buildPresetButton('30-70', 3, 7),
                  _buildPresetButton('100-0', 10, 0),
                  _buildPresetButton('0-100', 0, 10),
                  _buildPresetButton('40-60', 4, 6),
                ],
              ),
              const SizedBox(height: 90),
            ],
          ),
        ],
      ),
    );
  }

  // Helper function to build preset buttons.
  Widget _buildPresetButton(String label, int blueOn, int redOn) {
    return ElevatedButton(
      onPressed: () => _setPresetMode(blueOn, redOn),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        side: const BorderSide(color: Colors.black, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.tune,
            color: Colors.green,
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
