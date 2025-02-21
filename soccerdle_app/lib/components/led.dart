import 'package:flutter/material.dart';

class LEDBulbControlPage extends StatefulWidget {
  const LEDBulbControlPage({Key? key}) : super(key: key);

  @override
  _LEDBulbControlPageState createState() => _LEDBulbControlPageState();
}

class _LEDBulbControlPageState extends State<LEDBulbControlPage> {
  // List to track the on/off state for 20 LEDs (all initially off).
  final List<bool> ledStates = List<bool>.filled(20, false);

  // Returns the color for each LED bulb: gray if off, blue for first 10 when on, red for last 10.
  Color _getLEDBulbColor(int index) {
    return !ledStates[index]
        ? Colors.grey
        : index < 10
            ? const Color.fromARGB(255, 3, 85, 152)
            : const Color.fromARGB(255, 176, 19, 8);
  }

  // Background image as per LuxDisplayPage.
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

  // Function to set the LED states for different modes
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
                            fontSize: 24, // Title font size
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: ledStates.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5, // 5 bulbs per row.
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  // Toggle the state of the tapped bulb.
                                  ledStates[index] = !ledStates[index];
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                child: Icon(
                                  Icons.lightbulb,
                                  size: 50,
                                  color: _getLEDBulbColor(index),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 1), // Gap between container and buttons
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  _buildPresetButton('All On', 10, 10), // All LEDs On
                  _buildPresetButton('All Off', 0, 0), // All LEDs Off
                  _buildPresetButton('50-50', 5, 5),
                  _buildPresetButton('20-80', 2, 8),
                  _buildPresetButton('70-30', 7, 3),
                  _buildPresetButton('30-70', 3, 7),
                  _buildPresetButton('100-0', 10, 0),
                  _buildPresetButton('0-100', 0, 10),
                  _buildPresetButton('40-60', 4, 6),
                ],
              ),
              const SizedBox(height: 90), // Extra padding at the bottom
            ],
          ),
        ],
      ),
    );
  }

  // Helper function to build preset buttons
  Widget _buildPresetButton(String label, int blueOn, int redOn) {
    return ElevatedButton(
      onPressed: () => _setPresetMode(blueOn, redOn),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white, // Background color
        side: const BorderSide(color: Colors.black, width: 1.5),
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
            Icons.tune,
            color: Colors.green, // Icon color
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black, // Text color
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
