// providers/center_provider.dart
import 'package:flutter/material.dart';
import '../models/center_model.dart';
import '../services/center_api_service.dart';

class CenterProvider with ChangeNotifier {
  List<EducationalCenter> _centers = [];
  bool _isLoading = false;

  List<EducationalCenter> get centers => _centers;
  bool get isLoading => _isLoading;

  Future<void> fetchCenters(String regional) async {
    _isLoading = true;
    notifyListeners();

    try {
      _centers = await CenterApiService().fetchCenters(regional);
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
