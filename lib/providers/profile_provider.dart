import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  String _name = 'Técnico MINERD';
  String _email = 'tecnico@minerd.gob.do';
  String _profileImage = ''; // Ruta a la imagen de perfil

  String get name => _name;
  String get email => _email;
  String get profileImage => _profileImage;

  void setProfileImage(String path) {
    _profileImage = path;
    notifyListeners();
  }

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }
}
