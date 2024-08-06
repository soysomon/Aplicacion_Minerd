import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Información del Técnico'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/images/user.png'),
                ),
                SizedBox(height: 20),
                Text(
                  '${user.name} ${user.lastName}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.email, color: Color(0xFF0d427d)),
                    SizedBox(width: 10),
                    Text(
                      user.email,
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.phone, color: Color(0xFF0d427d)),
                    SizedBox(width: 10),
                    Text(
                      user.phone,
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ],
                ),
                Divider(height: 40, thickness: 1.5, color: Color(0xFF0d427d)),
                Text(
                  'Reflexión',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  '“La educación es el arma más poderosa que puedes usar para cambiar el mundo.” - Nelson Mandela',
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

