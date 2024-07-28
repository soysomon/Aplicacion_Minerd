import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'dart:io';
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

  Future<void> _playAudio() async {
    if (_isPlaying) {
      await _audioPlayer!.stopPlayer();
    } else {
      await _audioPlayer!.startPlayer(
        fromURI: widget.incident.audioPath,
        codec: Codec.defaultCodec,
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
        title: Text('Detalles de la Incidencia'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Título: ${widget.incident.title}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Centro: ${widget.incident.center}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Regional: ${widget.incident.regional}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Distrito: ${widget.incident.district}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Fecha: ${widget.incident.date}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Descripción: ${widget.incident.description}', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              widget.incident.photoPath.isNotEmpty
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.incident.photoPath.split(',').map((path) {
                  return Image.file(File(path), height: 100, width: 100);
                }).toList(),
              )
                  : Container(),
              SizedBox(height: 10),
              widget.incident.audioPath.isNotEmpty
                  ? ElevatedButton(
                onPressed: _playAudio,
                child: Text(_isPlaying ? 'Detener Audio' : 'Reproducir Audio'),
              )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
