import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'drawer_menu_screen.dart';
import 'visit_list_screen.dart';
import 'settings_screen.dart';
import 'map_screen.dart';
import 'news_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ZoomDrawerController _drawerController = ZoomDrawerController();
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    Center(child: Text('Home Page')),
    VisitListScreen(),
    MapScreen(),
    SettingsScreen(),
    NewsScreen(),
  ];

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
              'assets/icons/icon-menu.svg',
              width: 25,
              height: 25,
            ),
            onPressed: () {
              _drawerController.toggle?.call();
            },
          ),
        ),
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.ad_units),
              label: 'Visitas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined),
              label: 'Mapa',
            ),


            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Ajustes',
            ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.newspaper_outlined),
                  label: 'Noticias',
            ),
          ],
          selectedItemColor: Color(0xFF0d427d),
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
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
