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
          backgroundColor: Colors.transparent,
          elevation: 0,
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
              color: Colors.white,
            ),
            onPressed: () {
              _drawerController.toggle?.call();
            },
          ),
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF1A237E), // Azul oscuro profundo
                Color(0xFF3949AB), // Azul índigo
                Color(0xFF3F51B5), // Azul primario
                Color(0xFF5C6BC0), // Azul índigo claro
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.white.withOpacity(0.9),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Color(0xFF1A237E),
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            '../assets/icons/custom_icon.svg',
                            width: 60,
                            height: 60,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        '¡Bienvenido!',
                        style: GoogleFonts.dmSans(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Nos alegra verte de nuevo. Aquí puedes gestionar todas tus actividades.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          color: Color(0xFF3949AB),
                        ),
                      ),
                    ],
                  ),
                ),
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