import 'package:aplicacion_minerd/providers/center_provider.dart';
import 'package:aplicacion_minerd/screens/register_incident_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/incident_provider.dart';
import 'providers/visit_provider.dart';
import 'providers/news_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/user_provider.dart'; // Agregar el proveedor de usuario
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CenterProvider()),
        ChangeNotifierProvider(create: (_) => VisitProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()), // Proveedor de usuario
        ChangeNotifierProvider(create: (_) => IncidentProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicación MINERD',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
     },
     // home: RegisterIncidentScreen(),

    );
  }
}
