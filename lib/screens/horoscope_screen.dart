import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/horoscope_provider.dart';

class HoroscopeScreen extends StatelessWidget {
  final String sign;

  HoroscopeScreen({required this.sign});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HoroscopeProvider()..fetchHoroscope(sign),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Horóscopo del Día'),
        ),
        body: Consumer<HoroscopeProvider>(
          builder: (context, horoscopeProvider, child) {
            if (horoscopeProvider.isLoading) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Center(
                child: Text(
                  horoscopeProvider.horoscope.isNotEmpty
                      ? horoscopeProvider.horoscope
                      : 'Error al cargar el horóscopo.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
