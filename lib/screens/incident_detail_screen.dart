import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import '../models/incident.dart';

class IncidentDetailScreen extends StatefulWidget {
  final Incident incident;

  IncidentDetailScreen({required this.incident});

  @override
  _IncidentDetailScreenState createState() => _IncidentDetailScreenState();
}

class _IncidentDetailScreenState extends State<IncidentDetailScreen> {
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _player.openPlayer();
  }

  @override
  void dispose() {
    _player.closePlayer();
    super.dispose();
  }

  Future<void> _playPauseAudio() async {
    if (_isPlaying) {
      await _player.pausePlayer();
    } else {
      await _player.startPlayer(
        fromURI: widget.incident.audioPath,
        codec: Codec.aacADTS,
        whenFinished: () {
          setState(() {
            _isPlaying = false;
          });
        },
      );
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de Incidencia', style: TextStyle(color: Colors.black)),
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
              if (widget.incident.photoPath.isNotEmpty)
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: FileImage(File(widget.incident.photoPath)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              SizedBox(height: 20),
              _buildDetailRow(Icons.title, 'Título', widget.incident.title),
              _buildDetailRow(Icons.school, 'Centro', widget.incident.center),
              _buildDetailRow(Icons.map, 'Regional', widget.incident.regional),
              _buildDetailRow(Icons.location_city, 'Distrito', widget.incident.district),
              _buildDetailRow(Icons.calendar_today, 'Fecha', widget.incident.date),
              _buildDetailRow(Icons.description, 'Descripción', widget.incident.description),
              if (widget.incident.audioPath.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Audio:', style: TextStyle(fontSize: 18, color: Colors.black)),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _playPauseAudio,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      child: Text(_isPlaying ? 'Pausar Audio' : 'Reproducir Audio'),
                    ),
                  ],
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
