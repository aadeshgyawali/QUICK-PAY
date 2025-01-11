import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_notifier.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late String _firstName;
  late String _lastName;
  late String _phoneNumber;
  late String _email;
  late String _address;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserNotifier>(context, listen: false).user;
    _firstName = user.firstName;
    _lastName = user.lastName;
    _phoneNumber = user.phoneNumber;
    _email = user.email;
    _address = user.address;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: const Color(0xff0095FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                initialValue: _firstName,
                decoration: const InputDecoration(labelText: 'First Name'),
                onSaved: (value) {
                  _firstName = value ?? '';
                },
              ),
              TextFormField(
                initialValue: _lastName,
                decoration: const InputDecoration(labelText: 'Last Name'),
                onSaved: (value) {
                  _lastName = value ?? '';
                },
              ),
              TextFormField(
                initialValue: _phoneNumber,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                onSaved: (value) {
                  _phoneNumber = value ?? '';
                },
              ),
              TextFormField(
                initialValue: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                onSaved: (value) {
                  _email = value ?? '';
                },
              ),
              TextFormField(
                initialValue: _address,
                decoration: const InputDecoration(labelText: 'Address'),
                onSaved: (value) {
                  _address = value ?? '';
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final userNotifier = Provider.of<UserNotifier>(context, listen: false);
                    userNotifier.updateUser(
                      firstName: _firstName,
                      lastName: _lastName,
                      phoneNumber: _phoneNumber,
                      email: _email,
                      address: _address,
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
