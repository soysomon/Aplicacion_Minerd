import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          title: Text('Aplicación MINERD'),
          leading: IconButton(
            icon: SvgPicture.asset(
              'assets/icons/custom_icon.svg',
              width: 40,
              height: 40,
            ),
            onPressed: () {
              _drawerController.toggle?.call();
            },
          ),
        ),
        body: Center(
          child: Text('Welcome to Home Page'),
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
