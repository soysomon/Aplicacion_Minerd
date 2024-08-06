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
          _errorMessage = null;
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
        title: Text('Detalle de Visita', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_visit.photoPath.isNotEmpty)
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: FileImage(File(_visit.photoPath)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              SizedBox(height: 20),
              _buildDetailRow(Icons.person, 'Cédula del Director', _visit.directorId),
              _buildDetailRow(Icons.school, 'Código del Centro', _visit.centerCode),
              _buildDetailRow(Icons.assignment, 'Motivo de la Visita', _visit.reason),
              _buildDetailRow(Icons.comment, 'Comentario', _visit.comment),
              _buildDetailRow(Icons.calendar_today, 'Fecha', _visit.date),
              _buildDetailRow(Icons.access_time, 'Hora', _visit.time),
              _buildDetailRow(Icons.location_on, 'Latitud', _visit.latitude.toString()),
              _buildDetailRow(Icons.location_on, 'Longitud', _visit.longitude.toString()),
              if (_visit.audioPath.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Audio:', style: TextStyle(fontSize: 18, color: Colors.black)),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => _playAudio(_visit.audioPath),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      child: Text('Reproducir Audio'),
                    ),
                  ],
                ),
              if (_errorMessage != null)
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
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
