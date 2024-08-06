import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import '../providers/user_provider.dart';
import 'register_incident_screen.dart';
import 'incident_list_screen.dart';
import 'register_visit_screen.dart';
import 'map_screen.dart';
import 'visit_list_screen.dart';
import 'news_screen.dart';
import 'settings_screen.dart';
import 'login_screen.dart';

class DrawerMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xFF0d427d),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Consumer2<ProfileProvider, UserProvider>(
            builder: (context, profileProvider, userProvider, child) {
              return UserAccountsDrawerHeader(
                accountName: Text(
                  userProvider.user.name,
                  style: TextStyle(color: Colors.white),
                ),
                accountEmail: Text(
                  userProvider.user.lastName,
                  style: TextStyle(color: Colors.white),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: profileProvider.profileImage.isNotEmpty
                      ? FileImage(File(profileProvider.profileImage))
                      : AssetImage('assets/images/user.png') as ImageProvider,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFF0d427d),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.add, color: Colors.white),
            title: Text('Agregar Incidencia', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => RegisterIncidentScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.list, color: Colors.white),
            title: Text('Lista de Incidencias', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => IncidentListScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.school, color: Colors.white),
            title: Text('Registrar Visita', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => RegisterVisitScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.map, color: Colors.white),
            title: Text('Mapa de Visitas', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MapScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.list_alt, color: Colors.white),
            title: Text('Lista de Visitas', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => VisitListScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.newspaper, color: Colors.white),
            title: Text('Noticias', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => NewsScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.info, color: Colors.white),
            title: Text('Acerca de', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Implementar navegación
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.white),
            title: Text('Configuración', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.logout, color: Colors.white),
            title: Text('Logout', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
