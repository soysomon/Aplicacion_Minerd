import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/horoscope_provider.dart';

class HoroscopeScreen extends StatelessWidget {
  final DateTime birthDate;

  HoroscopeScreen({required this.birthDate});

  @override
  Widget build(BuildContext context) {
    final horoscopeProvider = Provider.of<HoroscopeProvider>(context);

    // Establecer la fecha de nacimiento para obtener el signo y el horóscopo
    horoscopeProvider.setBirthDate(birthDate);

    return Scaffold(
      appBar: AppBar(
        title: Text('Horóscopo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Color(0xFFE0E0F8), // Fondo moradito claro
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Signo Zodiacal',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0d427d),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      horoscopeProvider.zodiacSign,
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF0d427d).withOpacity(0.8),
                      ),
                    ),
                    Divider(
                      height: 30,
                      thickness: 1.5,
                      color: Color(0xFF0d427d),
                    ),
                    Text(
                      'Horóscopo del Día',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      horoscopeProvider.horoscope,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
