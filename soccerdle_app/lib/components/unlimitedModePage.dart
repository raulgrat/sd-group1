import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UnlimitedModePage extends StatefulWidget {
  static const String routeName = '/unlimitedModePage';
  const UnlimitedModePage({Key? key}) : super(key: key);

  @override
  _UnlimitedModeState createState() => _UnlimitedModeState();
}

class _UnlimitedModeState extends State<UnlimitedModePage> {
  final List<TextEditingController> guessControllers =
      List.generate(6, (_) => TextEditingController());
  String guess = '';
  List<String> guessesMade = List<String>.filled(6, '', growable: false);
  bool gameEnded = false;
  String hint = '';
  List<bool> hintdex = [false, false, false, false, false];
  String message = '';
  var dailyPlayer;
  int currentGuessIndex = 0;
  List<bool> _showHints = List.generate(6, (_) => false);

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  final String baseUrl = 'http://soccerdle-mern-ace81d4f14ec.herokuapp.com';

  void fetchData() async {
    try {
      http.Response response = await http.post(
        Uri.parse('$baseUrl/api/players/getRandomPlayer'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      var data = json.decode(response.body);
      setState(() {
        dailyPlayer = data;
      });
    } catch (e) {
      setState(() {
        message = 'Error occurred. Please try again later!';
      });
    }
  }

  void checkGuess() {
    if (guess.trim() == '') {
      return;
    }

    String trimmedGuess = guess.trim().toLowerCase();
    String correctNameLower = dailyPlayer['name'].toLowerCase();
    bool isCorrectGuess = trimmedGuess == correctNameLower;
    List<String> updatedGuessesMade = List.from(guessesMade);
    updatedGuessesMade[currentGuessIndex] = guess;

    setState(() {
      guessesMade = updatedGuessesMade;
      guess = '';

      if (isCorrectGuess || currentGuessIndex == 5) {
        gameEnded = true;
      } else {
        currentGuessIndex += 1;
      }
    });
  }

  void revealHint(int index) {
    var updatedHintdex = List<bool>.from(hintdex);
    updatedHintdex[index] = true;
    switch (index) {
      case 0:
        setState(() {
          hint = 'Nationality: ${dailyPlayer["nationality"]}';
        });
        break;
      case 1:
        setState(() {
          hint = 'Age: ${dailyPlayer["age"]}';
        });
        break;
      case 2:
        setState(() {
          hint = 'League: ${dailyPlayer["league"]}';
        });
        break;
      case 3:
        setState(() {
          hint = 'Club: ${dailyPlayer["club"]}';
        });
        break;
      case 4:
        setState(() {
          hint = 'Position: ${dailyPlayer["positions"]}';
        });
        break;
      default:
        setState(() {
          hint = '';
        });
    }
  }

  String getHint(int index) {
    switch (index) {
      case 0:
        return 'Nationality: ${dailyPlayer["nationality"]}';
      case 1:
        return 'Age: ${dailyPlayer["age"]}';
      case 2:
        return 'League: ${dailyPlayer["league"]}';
      case 3:
        return 'Club: ${dailyPlayer["club"]}';
      case 4:
        return 'Position: ${dailyPlayer["positions"]}';
      default:
        return '';
    }
  }

  void _hintRevealed(int index) {
    setState(() {
      _showHints[index] = !_showHints[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Unlimited Mode'),
        ),
        body: Stack(
          children: [
            _buildBackgroundImage(),
            unlimitedModeScreen(context),
          ],
        ),
      ),
    );
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

  Widget unlimitedModeScreen(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextFormField(),
        ],
      ),
    );
  }

  Widget _buildTextFormField() {
    List<Widget> previousGuessWidgets =
        List.generate(currentGuessIndex, (index) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Colors.green,
                  width: 1.0,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Guess ${index + 1}: ${guessesMade[index]}',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: _showHints[index] ? Colors.green : Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: _showHints[index]
                      ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getHint(index),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                if (index == 0)
                                  Image.network(dailyPlayer['country_flag']),
                                if (index == 3)
                                  Image.network(dailyPlayer['club_logo']),
                              ],
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            _hintRevealed(index);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Show Hint',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                )
              ],
            ),
          ),
        ],
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Column(
          children: <Widget>[
            for (var widget in previousGuessWidgets) ...[
              widget,
              SizedBox(height: 10),
            ],
          ],
        ),
        Center(
          child: Text(
            'Guess ${currentGuessIndex + 1}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextField(
          controller: guessControllers[currentGuessIndex],
          onChanged: (val) {
            setState(() {
              guess = val;
            });
          },
          onEditingComplete: () {
            setState(() {
              checkGuess();
            });
          },
          maxLength: 15,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter your guess here',
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintStyle: const TextStyle(color: Colors.black),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
        if (gameEnded)
          Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    guess.trim().toLowerCase() ==
                            dailyPlayer['name'].trim().toLowerCase()
                        ? 'You guessed it in ${guessesMade.length} ${guessesMade.length == 1 ? 'try!' : 'tries!'}'
                        : 'The player was ${dailyPlayer["name"]}',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 10),
                Image.network(
                  dailyPlayer['image'],
                  width: 150,
                ),
                SizedBox(height: 10),
                Image.network(
                  dailyPlayer['club_logo'],
                  width: 150,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          '/unlimitedModePage',
                        );
                      },
                      child: Text('Play Again'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/home',
                        );
                      },
                      child: Text('Home'),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}
