import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:geocoding/geocoding.dart';

import '../models/visit.dart';
import '../providers/visit_provider.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapController _mapController = MapController();
  LatLng _currentLocation =
      LatLng(18.486058, -69.931212); // Coordenadas de Santo Domingo

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

    Future<String> _getPlaceName(double latitude, double longitude) async {
      try {
        // ignore: unnecessary_null_comparison
        if (latitude == null || longitude == null) {
          return "${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}";
        }

        List<Placemark> placemarks =
            await placemarkFromCoordinates(latitude, longitude);
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks.first;
          return "${place.name ?? ''}, ${place.locality ?? ''}, ${place.country ?? ''}";
        }
      } catch (e) {
        print('Error occurred while fetching place name: $e');
      }
      return "${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}";
    }

    void _moveToLocation(LatLng location) {
      _mapController.move(location, 16.0);
    }

    void _fitBounds() {
      if (visits.isNotEmpty) {
        LatLngBounds bounds = LatLngBounds.fromPoints(
          visits
              .map((visit) => LatLng(visit.latitude, visit.longitude))
              .toList(),
        );
        _mapController.fitBounds(bounds,
            options: FitBoundsOptions(padding: EdgeInsets.all(20.0)));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa de Visitas'),
      ),
      body: visits.isNotEmpty
          ? FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: _calculateCenter(visits),
                zoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: visits.map((visit) {
                    return Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(visit.latitude, visit.longitude),
                      builder: (ctx) => GestureDetector(
                        onTap: () async {
                          _moveToLocation(
                              LatLng(visit.latitude, visit.longitude));
                          String placeName = await _getPlaceName(
                              visit.latitude, visit.longitude);
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Información de la Visita',
                                    style: TextStyle(fontSize: 22)),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: Icon(Icons.school),
                                      title: Text('Código del Centro',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      subtitle: Text(visit.centerCode),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.description),
                                      title: Text('Motivo',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      subtitle: Text(visit.reason),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.calendar_today),
                                      title: Text('Fecha',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      subtitle: Text(visit.date),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.access_time),
                                      title: Text('Hora',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      subtitle: Text(visit.time),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.location_on),
                                      title: Text('Ubicación',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      subtitle: Text(placeName),
                                    ),
                                  ],
                                ),
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
                        child: Icon(Icons.location_on,
                            size: 40.0, color: Colors.red),
                      ),
                    );
                  }).toList(),
                ),
              ],
            )
          : Center(child: Text('No hay visitas registradas')),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => _moveToLocation(_currentLocation),
            tooltip: 'Ubicación Actual',
            child: Icon(Icons.my_location),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _fitBounds,
            tooltip: 'Ajustar Vista',
            child: Icon(Icons.zoom_out_map),
          ),
        ],
      ),
    );
  }
}
