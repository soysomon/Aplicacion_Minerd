import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/visit.dart';
import '../providers/visit_provider.dart';

class RegisterVisitScreen extends StatefulWidget {
  @override
  _RegisterVisitScreenState createState() => _RegisterVisitScreenState();
}

class _RegisterVisitScreenState extends State<RegisterVisitScreen> {
  final _directorIdController = TextEditingController();
  final _centerCodeController = TextEditingController();
  final _reasonController = TextEditingController();
  final _commentController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _photoPath = '';
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
    _directorIdController.dispose();
    _centerCodeController.dispose();
    _reasonController.dispose();
    _commentController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
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

  Future<void> _selectTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _photoPath = pickedFile.path;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    var status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      status = await Permission.locationWhenInUse.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Permiso de ubicación denegado')),
        );
        return;
      }
    }

    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _latitudeController.text = position.latitude.toString();
      _longitudeController.text = position.longitude.toString();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ubicación obtenida: ${position.latitude}, ${position.longitude}')),
    );
  }

  Future<void> _saveVisit() async {
    if (_directorIdController.text.isEmpty ||
        _centerCodeController.text.isEmpty ||
        _reasonController.text.isEmpty ||
        _commentController.text.isEmpty ||
        _selectedDate == null ||
        _selectedTime == null ||
        _photoPath.isEmpty ||
        _audioPath.isEmpty ||
        (_latitudeController.text.isEmpty && _longitudeController.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor complete todos los campos obligatorios')),
      );
      return;
    }

    final visit = Visit(
      id: 0, // Proporciona un id temporal
      directorId: _directorIdController.text,
      centerCode: _centerCodeController.text,
      reason: _reasonController.text,
      photoPath: _photoPath,
      audioPath: _audioPath,
      latitude: _latitudeController.text.isNotEmpty ? double.parse(_latitudeController.text) : 0.0,
      longitude: _longitudeController.text.isNotEmpty ? double.parse(_longitudeController.text) : 0.0,
      date: _selectedDate.toString(),
      time: _selectedTime!.format(context),
      comment: _commentController.text,
    );

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Token no encontrado. Inicie sesión nuevamente.')),
      );
      return;
    }

    try {
      await Provider.of<VisitProvider>(context, listen: false).reportVisit(
        token: token,
        cedulaDirector: visit.directorId,
        codigoCentro: visit.centerCode,
        motivo: visit.reason,
        fotoEvidencia: visit.photoPath,
        comentario: visit.comment,
        notaVoz: visit.audioPath,
        latitud: visit.latitude.toString(),
        longitud: visit.longitude.toString(),
        fecha: visit.date,
        hora: visit.time,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Visita guardada exitosamente')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar la visita: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Visita'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _directorIdController,
              decoration: InputDecoration(labelText: 'Cédula del Director'),
            ),
            TextField(
              controller: _centerCodeController,
              decoration: InputDecoration(labelText: 'Código del Centro'),
            ),
            TextField(
              controller: _reasonController,
              decoration: InputDecoration(labelText: 'Motivo de la Visita'),
            ),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(labelText: 'Comentario'),
              maxLines: 3,
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  _selectedDate == null
                      ? 'Seleccione una fecha'
                      : 'Fecha: ${_selectedDate.toString().split(' ')[0]}',
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: _selectDate,
                  child: Text('Seleccionar Fecha'),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  _selectedTime == null
                      ? 'Seleccione una hora'
                      : 'Hora: ${_selectedTime!.format(context)}',
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: _selectTime,
                  child: Text('Seleccionar Hora'),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Tomar Foto'),
            ),
            _photoPath.isNotEmpty
                ? Image.file(File(_photoPath), height: 100, width: 100)
                : Container(),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _latitudeController,
                    decoration: InputDecoration(labelText: 'Latitud'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _longitudeController,
                    decoration: InputDecoration(labelText: 'Longitud'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _getCurrentLocation,
              child: Text('Obtener Ubicación Actual'),
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
                  child: Text(
                    _isRecording ? 'Grabando...' : _audioPath.isNotEmpty ? 'Audio Grabado' : 'Sin Audio',
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveVisit,
              child: Text('Guardar Visita'),
            ),
          ],
        ),
      ),
    );
  }
}