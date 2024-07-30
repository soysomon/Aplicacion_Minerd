import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';
import 'register_incident_screen.dart';
import 'incident_list_screen.dart';
import 'register_visit_screen.dart';
import 'map_screen.dart';
import 'visit_list_screen.dart';
import 'news_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import '../providers/profile_provider.dart';
import '../providers/user_provider.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Aplicación MINERD'),
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/custom_icon.svg',
            width: 40,
            height: 40,
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Consumer2<ProfileProvider, UserProvider>(
              builder: (context, profileProvider, userProvider, child) {
                return UserAccountsDrawerHeader(
                  accountName: Text(userProvider.user.name),
                  accountEmail: Text(userProvider.user.lastName),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: profileProvider.profileImage.isNotEmpty
                        ? FileImage(File(profileProvider.profileImage))
                        : AssetImage('assets/images/profile_placeholder.png') as ImageProvider,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    image: DecorationImage(
                      image: AssetImage('assets/images/profile_placeholder.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Agregar Incidencia'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => RegisterIncidentScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Lista de Incidencias'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => IncidentListScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.school),
              title: Text('Registrar Visita'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => RegisterVisitScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.map),
              title: Text('Mapa de Visitas'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => MapScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.list_alt),
              title: Text('Lista de Visitas'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => VisitListScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.newspaper),
              title: Text('Noticias'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => NewsScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Acerca de'),
              onTap: () {
                // Reemplaza con la ruta correspondiente cuando la pantalla esté creada
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configuración'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                // Implementar funcionalidad de logout
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Welcome to Home Page'),
      ),
    );
  }
}
