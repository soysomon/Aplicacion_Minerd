import 'package:flutter/material.dart';
import '../models/incident.dart';
import '../database/incident_database.dart';

class IncidentProvider with ChangeNotifier {
  List<Incident> _incidents = [];

  List<Incident> get incidents => _incidents;

  Future<void> addIncident(Incident incident) async {
    final newIncident = await IncidentDatabase.instance.create(incident);
    _incidents.add(newIncident);
    notifyListeners();
  }

  Future<void> loadIncidents() async {
    _incidents = await IncidentDatabase.instance.readAllIncidents();
    notifyListeners();
  }


  Future<void> updateIncident(Incident incident) async {
    await IncidentDatabase.instance.update(incident);
    final index = _incidents.indexWhere((i) => i.id == incident.id);
    if (index != -1) {
      _incidents[index] = incident;
      notifyListeners();
    }
  }

  Future<void> deleteIncident(int id) async {
    await IncidentDatabase.instance.delete(id);
    _incidents.removeWhere((i) => i.id == id);
    notifyListeners();
  }
}
