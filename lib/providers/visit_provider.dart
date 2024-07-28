import 'package:flutter/material.dart';
import '../models/visit.dart';
import '../database/visit_database.dart';

class VisitProvider with ChangeNotifier {
  List<Visit> _visits = [];

  List<Visit> get visits => _visits;

  Future<void> addVisit(Visit visit) async {
    final newVisit = await VisitDatabase.instance.create(visit);
    _visits.add(newVisit);
    notifyListeners();
  }

  Future<void> fetchVisits() async {
    _visits = await VisitDatabase.instance.readAllVisits();
    notifyListeners();
  }

  Future<void> updateVisit(Visit visit) async {
    await VisitDatabase.instance.update(visit);
    final index = _visits.indexWhere((v) => v.id == visit.id);
    if (index != -1) {
      _visits[index] = visit;
      notifyListeners();
    }
  }

  Future<void> deleteVisit(int id) async {
    await VisitDatabase.instance.delete(id);
    _visits.removeWhere((visit) => visit.id == id);
    notifyListeners();
  }
}
