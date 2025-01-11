import 'package:flutter/material.dart';

class User {
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String address;

  User({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.address,
  });
}

class UserNotifier extends ChangeNotifier {
  User _user = User(
    firstName: '',
    lastName: '',
    phoneNumber: '',
    email: '',
    address: '',
  );

  User get user => _user;

  void updateUser({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? email,
    String? address,
  }) {
    _user = User(
      firstName: firstName ?? _user.firstName,
      lastName: lastName ?? _user.lastName,
      phoneNumber: phoneNumber ?? _user.phoneNumber,
      email: email ?? _user.email,
      address: address ?? _user.address,
    );
    notifyListeners();
  }

  void updatePassword(String newPassword) {
    // Implement password update logic here
    notifyListeners();
  }
}
