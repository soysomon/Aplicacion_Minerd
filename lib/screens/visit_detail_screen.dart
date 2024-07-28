import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'dart:io';
import '../models/visit.dart';

class VisitDetailScreen extends StatefulWidget {
  final Visit visit;

  VisitDetailScreen({required this.visit});

  @override
  _VisitDetailScreenState createState() => _VisitDetailScreenState();
}

class _VisitDetailScreenState extends State<VisitDetailScreen> {
  final FlutterSoundPlayer _player = FlutterSoundPlayer();

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    await _player.openPlayer();
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
            Text('Cédula del Director: ${widget.visit.directorId}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Código del Centro: ${widget.visit.centerCode}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Motivo de la Visita: ${widget.visit.reason}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Comentario: ${widget.visit.comment}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Fecha: ${widget.visit.date}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Hora: ${widget.visit.time}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Latitud: ${widget.visit.latitude}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Longitud: ${widget.visit.longitude}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            if (widget.visit.photoPath.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Foto:', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  Image.file(File(widget.visit.photoPath), height: 200, width: 200),
                  SizedBox(height: 10),
                ],
              ),
            if (widget.visit.audioPath.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Audio:', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _playAudio(widget.visit.audioPath),
                    child: Text('Reproducir Audio'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
