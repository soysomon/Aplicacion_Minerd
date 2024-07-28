import 'package:flutter/material.dart';
import 'register_incident_screen.dart';
import 'incident_list_screen.dart';
import 'register_visit_screen.dart';
import 'map_screen.dart';
import 'visit_list_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aplicación MINERD'),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildMenuItem(
              context,
              icon: Icons.add,
              label: 'Agregar Incidencia',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RegisterIncidentScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            _buildMenuItem(
              context,
              icon: Icons.list,
              label: 'Lista de Incidencias',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => IncidentListScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            _buildMenuItem(
              context,
              icon: Icons.school,
              label: 'Registrar Visita',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RegisterVisitScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            _buildMenuItem(
              context,
              icon: Icons.list_alt,
              label: 'Lista de Visitas',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => VisitListScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            _buildMenuItem(
              context,
              icon: Icons.map,
              label: 'Mapa de Visitas',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MapScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            _buildMenuItem(
              context,
              icon: Icons.info,
              label: 'Acerca de',
              onPressed: () {
                // Reemplaza con la ruta correspondiente cuando la pantalla esté creada
              },
            ),
            SizedBox(height: 20),
            _buildMenuItem(
              context,
              icon: Icons.settings,
              label: 'Configuración',
              onPressed: () {
                // Reemplaza con la ruta correspondiente cuando la pantalla esté creada
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, {required IconData icon, required String label, required VoidCallback onPressed}) {
    return ListTile(
      leading: Icon(icon, size: 28, color: Colors.black),
      title: Text(
        label,
        style: TextStyle(fontSize: 18, color: Colors.black),
      ),
      onTap: onPressed,
      tileColor: Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
