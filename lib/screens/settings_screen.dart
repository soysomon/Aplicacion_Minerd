import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'change_password_screen.dart';
import 'security_screen.dart';
import 'about_screen.dart';
import 'home_screen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Configuración',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/custom_icon.svg',
            width: 40,
            height: 40,
          ),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomeScreen()),
                  (Route<dynamic> route) => false,
            );
          },
        ),
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
              trailing: Icon(Icons.chevron_right, color: Colors.black, size: 30),
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
              trailing: Icon(Icons.chevron_right, color: Colors.black, size: 30),
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
              trailing: Icon(Icons.chevron_right, color: Colors.black, size: 30),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
