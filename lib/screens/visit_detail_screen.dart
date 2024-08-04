import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'dart:io';
import '../models/visit.dart';
import 'package:provider/provider.dart';
import '../providers/visit_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VisitDetailScreen extends StatefulWidget {
  final Visit visit;

  VisitDetailScreen({required this.visit});

  @override
  _VisitDetailScreenState createState() => _VisitDetailScreenState();
}

class _VisitDetailScreenState extends State<VisitDetailScreen> {
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  late Visit _visit;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _visit = widget.visit;
    _initializePlayer();
    _fetchVisitDetails();
  }

  Future<void> _initializePlayer() async {
    await _player.openPlayer();
  }

  Future<void> _fetchVisitDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      try {
        final visitDetails = await Provider.of<VisitProvider>(context, listen: false)
            .fetchVisitDetails(token, _visit.id.toString());
        setState(() {
          _visit = visitDetails;
          _errorMessage = null;  // Limpiar mensaje de error si la carga es exitosa
        });
      } catch (e) {
        setState(() {
          _errorMessage = 'Error al cargar detalles de la visita: $e';
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Token no encontrado. Inicie sesión nuevamente.';
      });
    }
  }

  Future<void> _playAudio(String audioPath) async {
    await _player.startPlayer(fromURI: audioPath);
  }

  @override
  void dispose() {
    _player.closePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de Visita'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_visit.photoPath.isNotEmpty)
              Image.file(File(_visit.photoPath)),
            SizedBox(height: 10),
            Text('Cédula del Director: ${_visit.directorId}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Código del Centro: ${_visit.centerCode}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Motivo de la Visita: ${_visit.reason}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Comentario: ${_visit.comment}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Fecha: ${_visit.date}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Hora: ${_visit.time}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Latitud: ${_visit.latitude}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Longitud: ${_visit.longitude}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            if (_visit.audioPath.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Audio:', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _playAudio(_visit.audioPath),
                    child: Text('Reproducir Audio'),
                  ),
                ],
              ),
            if (_errorMessage != null) // Mostrar mensaje de error si existe
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
