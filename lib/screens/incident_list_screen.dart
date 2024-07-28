import 'package:flutter/material.dart';
import 'incident_detail_screen.dart';
import '../models/incident.dart';
import '../database/incident_database.dart';

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
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshIncidents,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
