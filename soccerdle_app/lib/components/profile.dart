import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:soccerdle_app/services/loginPageServices.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = '/profile';
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String display = Storage.getName();
  String newName = Storage.getName();
  String newUsername = Storage.getUser();
  String message = '';

  final String baseUrl = 'https://sd-group1-7db20f01361c.herokuapp.com';

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/obtainUser'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': Storage.getUser(),
        }),
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body)['user'];
        setState(() {
          newName = userData['name'];
          newUsername = userData['username'];
          display = userData['name'];
        });
      } else {
        setState(() {
          message = 'Failed to fetch user data';
        });
      }
    } catch (e) {
      setState(() {
        message = 'Error: $e';
      });
    }
  }

  Future<void> changeName(String newName) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/updateName'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'newName': newName,
          'username': Storage.getUser(),
        }),
      );

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        if (res['error'] != null) {
          setState(() {
            message = res['error'];
          });
        } else {
          setState(() {
            message = res['message'];
            newName = res['newName'];
            Storage.setName(newName);
            display = newName;
          });
        }
      } else {
        setState(() {
          message = 'Failed to update name';
        });
      }
    } catch (e) {
      setState(() {
        message = 'Internal Server Error: $e';
      });
    }
  }

  Future<void> changeUsername(String newUse) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/updateUsername'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'newUsername': newUse,
          'username': Storage.getUser(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final res = jsonDecode(response.body);
        setState(() {
          message = res['message'];
          newUsername = res['newUser'];
          Storage.setUser(newUsername);
        });
      } else if (response.statusCode == 400) {
        setState(() {
          message = 'Username already existed';
        });
      } else {
        setState(() {
          message = 'Failed to update Username!';
        });
      }
    } catch (e) {
      setState(() {
        message = 'Internal Server Error: $e';
      });
    }
  }

  Future<void> deleteUser() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/deleteUser'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': Storage.getUser(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final res = jsonDecode(response.body);
        setState(() {
          message = res['error'];
          logout();
        });
      } else {
        setState(() {
          message = 'Failed to delete account';
        });
      }
    } catch (e) {
      setState(() {
        message = 'Internal Server Error: $e';
      });
    }
  }

  void logout() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  void goHome(BuildContext context) {
    Navigator.pushNamed(context, '/home');
  }

  void playDaily(BuildContext context) {
    Navigator.pushNamed(context, '/luxDisplay');
  }

  void goUnlimited(BuildContext context) {
    Navigator.pushNamed(context, '/sensorDataDisplay');
  }

  void goLeaderboard(BuildContext context) {
    Navigator.pushNamed(context, '/ledControl');
  }

  void goAllTime(BuildContext context) {
    Navigator.pushNamed(context, '/allTimeLeaderboard');
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

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile info header
        const Center(
          child: Text(
            'Profile Information',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
          const Divider(thickness: 1, height: 20),
          // Display current name and username in a row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Name:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(display, style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Username:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(newUsername, style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Form for updating name and username
          const Text(
            'Update Your Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TextFormField(
            initialValue: newName,
            onChanged: (value) {
              setState(() {
                newName = value;
              });
            },
            decoration: const InputDecoration(
              labelText: 'New Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          // Left-aligned update button
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              onPressed: () async {
                await changeName(newName);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff7eaf34),
                foregroundColor: Colors.black,
                side: const BorderSide(color: Colors.black, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              ),
              child: const Text('Update Name'),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            initialValue: newUsername,
            onChanged: (value) {
              setState(() {
                newUsername = value;
              });
            },
            decoration: const InputDecoration(
              labelText: 'New Username',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              onPressed: () async {
                await changeUsername(newUsername);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff7eaf34),
                foregroundColor: Colors.black,
                side: const BorderSide(color: Colors.black, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              ),
              child: const Text('Update Username'),
            ),
          ),
          const SizedBox(height: 20),
          // Delete account button (left-aligned)
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              onPressed: () {
                // Show confirmation dialog to delete account
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm'),
                      content: const Text(
                          'Are you sure you want to delete your account?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pop(); // Close the dialog
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.of(context)
                                .pop(); // Close the dialog
                            await deleteUser(); // Call deleteUser function
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.black,
                side: const BorderSide(color: Colors.black, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              ),
              child: const Text('Delete Account'),
            ),
          ),
          const SizedBox(height: 10),
          if (message.isNotEmpty)
            Text(
              message,
              style: const TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            color: const Color(0xff7eaf34),
            height: 120,
            padding: const EdgeInsets.only(left: 16, top: 30, bottom: 10),
            alignment: Alignment.bottomLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Signed in as:',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  Storage.getName(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Home Page'),
            onTap: () {
              Navigator.pop(context);
              goHome(context);
            },
          ),
          ListTile(
            title: const Text('Analyzer of Blue to Red Light'),
            onTap: () {
              Navigator.pop(context);
              playDaily(context);
            },
          ),
          ListTile(
            title: const Text('Temperature Readings'),
            onTap: () {
              Navigator.pop(context);
              goUnlimited(context);
            },
          ),
          ListTile(
            title: const Text('LED Controller'),
            onTap: () {
              Navigator.pop(context);
              goLeaderboard(context);
            },
          ),
          ListTile(
            title: const Text('CO2 Readings'),
            onTap: () {
              Navigator.pop(context);
              goAllTime(context);
            },
          ),
          ListTile(
            title: const Text('About Us'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/aboutUs');
            },
          ),
        ],
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
        backgroundColor: Colors.grey.shade200.withOpacity(0.5),
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: const Color.fromARGB(255, 157, 21, 21),
            onPressed: logout,
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: Stack(
        children: [
          _buildBackgroundImage(),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: _buildProfileCard(),
          ),
        ],
      ),
    );
  }
}
