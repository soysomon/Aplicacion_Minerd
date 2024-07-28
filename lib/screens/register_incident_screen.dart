import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sound/flutter_sound.dart';
import '../models/incident.dart';
import '../providers/incident_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RegisterIncidentScreen extends StatefulWidget {
  @override
  _RegisterIncidentScreenState createState() => _RegisterIncidentScreenState();
}

class _RegisterIncidentScreenState extends State<RegisterIncidentScreen> {
  final _titleController = TextEditingController();
  final _centerController = TextEditingController();
  final _regionalController = TextEditingController();
  final _districtController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  List<String> _photoPaths = [];
  String _audioPath = '';
  FlutterSoundRecorder? _audioRecorder;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _audioRecorder = FlutterSoundRecorder();
    _openAudioSession();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _centerController.dispose();
    _regionalController.dispose();
    _districtController.dispose();
    _descriptionController.dispose();
    _closeAudioSession();
    super.dispose();
  }

  Future<void> _openAudioSession() async {
    await _audioRecorder!.openRecorder();
  }

  Future<void> _closeAudioSession() async {
    await _audioRecorder!.closeRecorder();
  }

  Future<void> _startRecording() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = '${tempDir.path}/flutter_sound.aac';
    await _audioRecorder!.startRecorder(toFile: tempPath);
    setState(() {
      _audioPath = tempPath;
      _isRecording = true;
    });
  }

  Future<void> _stopRecording() async {
    await _audioRecorder!.stopRecorder();
    setState(() {
      _isRecording = false;
    });
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _photoPaths.add(pickedFile.path);
      });
    }
  }

  Future<void> _saveIncident() async {
    if (_titleController.text.isEmpty ||
        _centerController.text.isEmpty ||
        _regionalController.text.isEmpty ||
        _districtController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _selectedDate == null ||
        _photoPaths.isEmpty ||
        _audioPath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Por favor complete todos los campos'),
      ));
      return;
    }

    final incident = Incident(
      title: _titleController.text,
      center: _centerController.text,
      regional: _regionalController.text,
      district: _districtController.text,
      date: _selectedDate.toString(),
      description: _descriptionController.text,
      photoPath: _photoPaths.join(','), // Join multiple photo paths
      audioPath: _audioPath,
    );

    try {
      await Provider.of<IncidentProvider>(context, listen: false).addIncident(incident);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Datos guardados exitosamente'),
      ));
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al guardar la incidencia: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Incidencia'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: _centerController,
              decoration: InputDecoration(labelText: 'Centro'),
            ),
            TextField(
              controller: _regionalController,
              decoration: InputDecoration(labelText: 'Regional'),
            ),
            TextField(
              controller: _districtController,
              decoration: InputDecoration(labelText: 'Distrito'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descripción'),
              maxLines: 3,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? 'Seleccione una fecha'
                        : 'Fecha: ${_selectedDate.toString().split(' ')[0]}',
                  ),
                ),
                ElevatedButton(
                  onPressed: _selectDate,
                  child: Text('Seleccionar Fecha'),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text('Fotos seleccionadas: ${_photoPaths.length}'),
                ),
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  child: Text('Seleccionar Foto'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.camera),
                  child: Text('Tomar Foto'),
                ),
              ],
            ),
            SizedBox(height: 10),
            Column(
              children: _photoPaths.map((path) {
                return Image.file(File(path), height: 100, width: 100);
              }).toList(),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _isRecording ? _stopRecording : _startRecording,
                  child: Text(_isRecording ? 'Detener Grabación' : 'Grabar Audio'),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(_isRecording ? 'Grabando...' : _audioPath.isNotEmpty ? 'Audio Grabado' : 'Sin Audio'),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveIncident,
              child: Text('Guardar Incidencia'),
            ),
          ],
        ),
      ),
    );
  }
}
