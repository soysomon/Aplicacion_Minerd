import 'package:aplicacion_minerd/providers/registro_api.dart';
import 'package:aplicacion_minerd/screens/forgot_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/incident_provider.dart';
import 'providers/visit_provider.dart';
import 'providers/news_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/user_provider.dart';
import 'providers/registro_api.dart'; // Agregar el proveedor de registro
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart'; // Importar la pantalla de registro
import 'screens/change_password_screen.dart'; // Importar la pantalla de cambio de clave

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VisitProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => IncidentProvider()),
        Provider(create: (_) => RegistroApi()), // Proveedor de registro

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
        '/register': (context) => RegisterScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),

        '/change-password': (context) => ChangePasswordScreen(),
      },
    );
  }
}
