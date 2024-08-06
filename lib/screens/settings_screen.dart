import 'package:flutter/material.dart';
import 'change_password_screen.dart';
import 'security_screen.dart';
import 'about_screen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Configuración'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            SizedBox(height: 20),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.security, color: Color(0xFF0d427d), size: 25),
              title: Text(
                'Seguridad',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              trailing:
                  Icon(Icons.chevron_right, color: Colors.black, size: 30),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SecurityScreen()),
                );
              },
            ),
            Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.info, color: Color(0xFF0d427d), size: 25),
              title: Text(
                'Acerca de',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              trailing:
                  Icon(Icons.chevron_right, color: Colors.black, size: 30),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AboutScreen()),
                );
              },
            ),
            Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.lock, color: Color(0xFF0d427d), size: 25),
              title: Text(
                'Cambiar clave',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              trailing:
                  Icon(Icons.chevron_right, color: Colors.black, size: 30),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => ChangePasswordScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
