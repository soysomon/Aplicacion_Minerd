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
  FlutterSoundPlayer? _audioPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = FlutterSoundPlayer();
    _openAudioSession();
  }

  @override
  void dispose() {
    _closeAudioSession();
    super.dispose();
  }

  Future<void> _openAudioSession() async {
    await _audioPlayer!.openPlayer();
  }

  Future<void> _closeAudioSession() async {
    await _audioPlayer!.closePlayer();
  }

  Future<void> _playPauseAudio() async {
    if (_isPlaying) {
      await _audioPlayer!.pausePlayer();
    } else {
      await _audioPlayer!.startPlayer(
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
        title: Text('Detalle de Incidencia'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Título: ${widget.incident.title}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Centro: ${widget.incident.center}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Regional: ${widget.incident.regional}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Distrito: ${widget.incident.district}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Fecha: ${widget.incident.date}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Descripción: ${widget.incident.description}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Fotos:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            _buildPhotoGallery(),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _playPauseAudio,
              child: Text(_isPlaying ? 'Pausar Audio' : 'Reproducir Audio'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoGallery() {
    List<String> photoPaths = widget.incident.photoPath.split(',');

    return Column(
      children: photoPaths.map((path) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Image.file(File(path), height: 100, width: 100),
        );
      }).toList(),
    );
  }
}
