import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
            'Settings',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 30,
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
              leading: Icon(Icons.security, color: Colors.black, size: 30),
              title: Text(
                'Seguridad',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
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
              leading: Icon(Icons.info, color: Colors.black, size: 30),
              title: Text(
                'Acerca de',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
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
              title: Text(
                'Use decimal within amounts',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              trailing: Switch(
                value: true,
                onChanged: (bool value) {},
              ),
            ),
            Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.category, color: Colors.black, size: 30),
              title: Text(
                'Categorías',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              trailing: Icon(Icons.chevron_right, color: Colors.black, size: 30),
              onTap: () {
                // Acción al pulsar
              },
            ),
            Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.lock, color: Colors.black, size: 30),
              title: Text(
                'Privacy',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              trailing: Icon(Icons.chevron_right, color: Colors.black, size: 30),
              onTap: () {
                // Acción al pulsar
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SecurityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seguridad'),
      ),
      body: Center(
        child: Text('Pantalla de Seguridad'),
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acerca de'),
      ),
      body: Center(
        child: Text('Pantalla Acerca de'),
      ),
    );
  }
}
