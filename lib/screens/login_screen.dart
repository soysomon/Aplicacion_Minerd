import 'package:flutter/material.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    // Implement login logic here
    // For example, you could use an API service to authenticate the user

    // After successful login, save user data in UserProvider
    final user = User(
      id: 1,
      name: 'John',
      lastName: 'Doe',
      registrationNumber: '123456',
      photoUrl: 'https://example.com/photo.jpg',
    );

    Provider.of<UserProvider>(context, listen: false).setUser(user);

    // Navigate to home screen
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
