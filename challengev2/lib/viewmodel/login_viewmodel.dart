import 'package:flutter/material.dart';

import '../models/database_helper.dart';
import '../models/user_model.dart';


class LoginViewModel {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> login(BuildContext context, String username, String password) async {
    if (username == 'tomi' && password == 'password') {
      UserModel user = UserModel(username: username, password: password);
      await _saveUserToPrefs(user);
      _navigateToHome(context, user);
    } else {
      _showErrorDialog(context, 'Invalid username or password');
    }
  }

  Future<void> _saveUserToPrefs(UserModel user) async {
    // Simpan informasi pengguna ke SharedPreferences atau penyimpanan yang sesuai
  }

  void _navigateToHome(BuildContext context, UserModel user) {
    Navigator.pushReplacementNamed(context, '/home', arguments: user);
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
          actions: [
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
