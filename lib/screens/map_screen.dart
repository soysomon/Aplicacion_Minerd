import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:geocoding/geocoding.dart';

import '../models/visit.dart';
import '../providers/user_provider.dart';
import '../providers/visit_provider.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapController _mapController = MapController();
  LatLng _defaultLocation =
      LatLng(18.7357, -70.1627); // Coordenadas de la República Dominicana

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final visitProvider = Provider.of<VisitProvider>(context, listen: false);

      visitProvider.fetchVisits(userProvider.user.token).then((_) {
        _mapController.move(_defaultLocation, 8.0);
      });
    });
  }

  LatLng _calculateCenter(List<Visit> visits) {
    List<double> latitudes = visits.map((visit) => visit.latitude).toList();
    List<double> longitudes = visits.map((visit) => visit.longitude).toList();

    double averageLatitude =
        latitudes.reduce((a, b) => a + b) / latitudes.length;
    double averageLongitude =
        longitudes.reduce((a, b) => a + b) / longitudes.length;

    return LatLng(averageLatitude, averageLongitude);
  }

  Future<String> _getPlaceName(double latitude, double longitude) async {
    try {
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
    _mapController.move(location, 18.0);
  }

  void _moveToDefaultLocation(LatLng location) {
    _mapController.move(location, 8.0);
  }

  void _fitBounds() {
    final visitProvider = Provider.of<VisitProvider>(context, listen: false);
    final visits = visitProvider.visits;

    if (visits.isNotEmpty) {
      LatLngBounds bounds = LatLngBounds.fromPoints(
        visits.map((visit) => LatLng(visit.latitude, visit.longitude)).toList(),
      );
      _mapController.fitBounds(bounds,
          options: FitBoundsOptions(padding: EdgeInsets.all(20.0)));
    } else {
      // Ajustar el mapa para mostrar la República Dominicana si no hay visitas
      _mapController.move(
          _defaultLocation, 8.0); // Zoom más amplio para ver todo el país
    }
  }

  @override
  Widget build(BuildContext context) {
    final visitProvider = Provider.of<VisitProvider>(context);
    final visits = visitProvider.visits;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa de Visitas'),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: _defaultLocation,
          zoom: 8.0, // Zoom para ver toda la República Dominicana
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
                  onTap: () async {
                    _moveToLocation(LatLng(visit.latitude, visit.longitude));
                    String placeName =
                        await _getPlaceName(visit.latitude, visit.longitude);
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(visit.centerCode),
                              ),
                              ListTile(
                                leading: Icon(Icons.description),
                                title: Text('Motivo',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(visit.reason),
                              ),
                              ListTile(
                                leading: Icon(Icons.calendar_today),
                                title: Text('Fecha',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(visit.date),
                              ),
                              ListTile(
                                leading: Icon(Icons.access_time),
                                title: Text('Hora',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(visit.time),
                              ),
                              ListTile(
                                leading: Icon(Icons.location_on),
                                title: Text('Ubicación',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
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
                  child: Icon(Icons.location_on, size: 40.0, color: Colors.red),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => _moveToDefaultLocation(_defaultLocation),
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
