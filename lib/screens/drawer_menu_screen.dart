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
      color: Colors.white, // Fondo blanco
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Consumer2<ProfileProvider, UserProvider>(
            builder: (context, profileProvider, userProvider, child) {
              return UserAccountsDrawerHeader(
                accountName: Text(
                  userProvider.user.name,
                  style: TextStyle(color: Colors.black), // Texto negro
                ),
                accountEmail: Text(
                  userProvider.user.lastName,
                  style: TextStyle(color: Colors.black), // Texto negro
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: profileProvider.profileImage.isNotEmpty
                      ? FileImage(File(profileProvider.profileImage))
                      : AssetImage('assets/images/user.png') as ImageProvider,
                ),
                decoration: BoxDecoration(
                  color: Colors.white, // Fondo blanco
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.add, color: Colors.black), // Ícono negro
            title: Text('Agregar Incidencia', style: TextStyle(color: Colors.black)), // Texto negro
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => RegisterIncidentScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.list, color: Colors.black), // Ícono negro
            title: Text('Lista de Incidencias', style: TextStyle(color: Colors.black)), // Texto negro
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => IncidentListScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.school, color: Colors.black), // Ícono negro
            title: Text('Registrar Visita', style: TextStyle(color: Colors.black)), // Texto negro
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => RegisterVisitScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.map, color: Colors.black), // Ícono negro
            title: Text('Mapa de Visitas', style: TextStyle(color: Colors.black)), // Texto negro
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MapScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.list_alt, color: Colors.black), // Ícono negro
            title: Text('Lista de Visitas', style: TextStyle(color: Colors.black)), // Texto negro
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => VisitListScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.newspaper, color: Colors.black), // Ícono negro
            title: Text('Noticias', style: TextStyle(color: Colors.black)), // Texto negro
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => NewsScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.info, color: Colors.black), // Ícono negro
            title: Text('Acerca de', style: TextStyle(color: Colors.black)), // Texto negro
            onTap: () {
              // Implementar navegación
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.black), // Ícono negro
            title: Text('Configuración', style: TextStyle(color: Colors.black)), // Texto negro
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.black), // Ícono negro
            title: Text('Logout', style: TextStyle(color: Colors.black)), // Texto negro
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
