import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:soccerdle_app/services/loginPageServices.dart';

class LeaderBoardPage extends StatefulWidget {
  static const String routeName = '/leaderBoard';
  const LeaderBoardPage({Key? key}) : super(key: key);
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<LeaderBoardPage> {
  List<User> users = [];
  String message = '';

  @override
  void initState() {
    super.initState();
    fetchPlayers();
  }

  final String baseUrl = 'https://sd-group1-7db20f01361c.herokuapp.com/';
  Future<void> fetchPlayers() async {
    try {
      http.Response response = await http.post(
        Uri.parse('$baseUrl/api/daily/leaderboard'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      var data = json.decode(response.body) as List;
      setState(() {
        users = data.map((user) => User.fromJson(user)).toList();
      });
    } catch (e) {
      setState(() {
        message = 'Error occurred. Please try again later!';
      });
    }
  }

  @override
Widget build(BuildContext context) {
  return Center(
    child: SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'New Readings',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text('readings',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: users.where((user) => user.dailyScore > 0).length,
                itemBuilder: (context, index) {
                  var players =
                      users.where((user) => user.dailyScore > 0).toList();
                  return Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      color: players[index].name == Storage.getName() ? Colors.green.withOpacity(0.3) : Colors.transparent,
                    ),
                    margin: EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${index + 1}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            if (index < 3)
                              Text(index == 0
                                  ? '🥇'
                                  : index == 1
                                      ? '🥈'
                                      : '🥉'),
                            Text(players[index].name,
                                style: TextStyle(fontSize: 18)),
                          ],
                        ),
                        Text('${players[index].dailyScore}',
                            style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      ),
    ),
    );
  }
}

class User {
  final String name;
  final int dailyScore;

  User({required this.name, required this.dailyScore});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      dailyScore: json['dailyScore'],
    );
  }
}
