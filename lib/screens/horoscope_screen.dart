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
        child: Column(
          children: [
            Text('Signo: ${horoscopeProvider.zodiacSign}',
                style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Text('Horóscopo: ${horoscopeProvider.horoscope}',
                style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
