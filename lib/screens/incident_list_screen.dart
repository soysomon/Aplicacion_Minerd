import 'package:flutter/material.dart';
import 'package:fan_floating_menu/fan_floating_menu.dart';
import 'incident_detail_screen.dart';
import '../models/incident.dart';
import '../database/incident_database.dart';
import 'register_visit_screen.dart';
import 'register_incident_screen.dart';

class IncidentListScreen extends StatefulWidget {
  @override
  _IncidentListScreenState createState() => _IncidentListScreenState();
}

class _IncidentListScreenState extends State<IncidentListScreen> {
  late Future<List<Incident>> _incidentsFuture;

  @override
  void initState() {
    super.initState();
    _incidentsFuture = IncidentDatabase.instance.readAllIncidents();
  }

  void _refreshIncidents() {
    setState(() {
      _incidentsFuture = IncidentDatabase.instance.readAllIncidents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Incidencias'),
      ),
      body: FutureBuilder<List<Incident>>(
        future: _incidentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar las incidencias'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay incidencias registradas'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final incident = snapshot.data![index];
                return ListTile(
                  title: Text(incident.title),
                  subtitle: Text('${incident.date} - ${incident.center}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IncidentDetailScreen(incident: incident),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FanFloatingMenu(
        menuItems: [
          FanMenuItem(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => RegisterVisitScreen()),
              );
            },
            icon: Icons.person_add_alt_1_rounded,
            title: 'Registrar Visita',
          ),
          FanMenuItem(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => RegisterIncidentScreen()),
              );
            },
            icon: Icons.add_alert_rounded,
            title: 'Registrar Incidencia',
          ),
          FanMenuItem(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => IncidentListScreen()),
              );
            },
            icon: Icons.list_alt_rounded,
            title: 'Lista de Incidencias',
          ),
        ],
      ),
    );
  }
}
