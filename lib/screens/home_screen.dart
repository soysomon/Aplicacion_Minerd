import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'drawer_menu_screen.dart';

class HomeScreen extends StatelessWidget {
  final ZoomDrawerController _drawerController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: _drawerController,
      menuScreen: DrawerMenuScreen(),
      mainScreen: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF003876), // Fondo azul oscuro
          title: Text(
            'Aplicación MINERD',
            style: GoogleFonts.dmSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            icon: SvgPicture.asset(
              'assets/icons/icon-menu.svg',
              width: 25,
              height: 25,
              color: Colors.white, // Botón de menú blanco
            ),
            onPressed: () {
              _drawerController.toggle?.call();
            },
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF003876), // Azul oscuro
                Color(0xFF0072CE), // Azul medio
                Color(0xFF4A90E2), // Azul claro
                Color(0xFFE9C46A), // Amarillo claro (opcional para contraste)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        '../assets/icons/home_icon.svg', // Cambia el archivo del ícono aquí
                        width: 80,
                        height: 80,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '¡Bienvenido!',
                    style: GoogleFonts.dmSans(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF003876),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Nos alegra verte de nuevo. Aquí puedes gestionar todas tus actividades.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      color: Color(0xFF003876),
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      // Acción al presionar el botón
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      child: Text(
                        'Ir al Dashboard',
                        style: GoogleFonts.dmSans(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      borderRadius: 24.0,
      showShadow: true,
      angle: 0.0,
      backgroundColor: Colors.grey[300] ?? Colors.grey,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
      openCurve: Curves.fastOutSlowIn,
      closeCurve: Curves.bounceIn,
    );
  }
}
