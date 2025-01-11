import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String name;
  late String phoneNumber;
  late String registrationNo;
  late String email;
  late String address;
  final String appName = "Quick Pay";
  final String profilePicUrl = "https://via.placeholder.com/150";

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = "${prefs.getString('firstName') ?? ''} ${prefs.getString('lastName') ?? ''}";
      phoneNumber = prefs.getString('phone') ?? '';
      registrationNo = prefs.getString('registrationNo') ?? '';
      email = prefs.getString('email') ?? '';
      address = prefs.getString('address') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Top part with basic user information
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(profilePicUrl),
                  radius: 40,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text('Phone: $phoneNumber', style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    Text('Registration No: $registrationNo', style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Center(
              child: Text(
                'Basic Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Middle part with additional information
            const Text('App Name: Quick Pay', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Text('Phone: $phoneNumber', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Text('Email: $email', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Text('Address: $address', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}


