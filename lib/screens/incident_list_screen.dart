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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, // Fondo blanco
        iconTheme: IconThemeData(
          color: Colors.black, // Color de los iconos en negro
        ),
        title: Text(
          '',
          style: TextStyle(color: Colors.black), // Color del texto en negro
        ),
        elevation: 0, // Elimina la sombra para un diseño más plano
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Incidencias Registradas',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Buscar por Cédula del Director',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: 'Buscar',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              onChanged: (value) {
                setState(() {
                  // Implementar la lógica de búsqueda aquí si es necesario
                });
              },
            ),
            SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Incident>>(
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
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(
                              incident.title,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text('${incident.date} - ${incident.center}'),
                            leading: Icon(Icons.location_city, color: Colors.blue),
                            trailing: Icon(Icons.arrow_forward, color: Colors.blue),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => IncidentDetailScreen(incident: incident),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),

    );
  }
}