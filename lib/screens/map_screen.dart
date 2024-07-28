import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../models/visit.dart';
import '../providers/visit_provider.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final visitProvider = Provider.of<VisitProvider>(context);
    final visits = visitProvider.visits;

    double _calculateAverage(List<double> values) {
      return values.reduce((a, b) => a + b) / values.length;
    }

    LatLng _calculateCenter(List<Visit> visits) {
      List<double> latitudes = visits.map((visit) => visit.latitude).toList();
      List<double> longitudes = visits.map((visit) => visit.longitude).toList();

      double averageLatitude = _calculateAverage(latitudes);
      double averageLongitude = _calculateAverage(longitudes);

      return LatLng(averageLatitude, averageLongitude);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa de Visitas'),
      ),
      body: visits.isNotEmpty
          ? FlutterMap(
        options: MapOptions(
          center: _calculateCenter(visits),
          zoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: visits.map((visit) {
              return Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(visit.latitude, visit.longitude),
                builder: (ctx) => GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Información de la Visita'),
                          content: Text(
                              'Código del Centro: ${visit.centerCode}\nMotivo: ${visit.reason}\nComentario: ${visit.comment}\nUbicación: ${visit.latitude}, ${visit.longitude}'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cerrar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Icon(Icons.location_on, size: 40.0, color: Colors.red),
                ),
              );
            }).toList(),
          ),
        ],
      )
          : Center(
        child: Text('No hay visitas registradas'),
      ),
    );
  }
}