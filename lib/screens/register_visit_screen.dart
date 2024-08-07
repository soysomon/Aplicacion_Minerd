import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../models/visit.dart';
import '../providers/visit_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

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
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Color(0xFF003876),
        elevation: 0,
        title: Text('Registrar Visita', style: GoogleFonts.dmSans(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFF003876),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),

              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextField(_directorIdController, 'Cédula del Director', Icons.person),
                    SizedBox(height: 15),
                    _buildTextField(_centerCodeController, 'Código del Centro', Icons.school),
                    SizedBox(height: 15),
                    _buildTextField(_reasonController, 'Motivo de la Visita', Icons.description),
                    SizedBox(height: 15),
                    _buildTextField(_commentController, 'Comentario', Icons.comment, maxLines: 3),
                    SizedBox(height: 15),
                    _buildDatePicker(),
                    SizedBox(height: 15),
                    _buildTimePicker(),
                    SizedBox(height: 15),
                    _buildImagePicker(),
                    SizedBox(height: 15),
                    _buildAudioRecorder(),
                    SizedBox(height: 15),
                    _buildLocationFields(), // Actualización aquí
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _saveVisit,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          'Guardar Visita',
                          style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), // Letras blancas
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF003876),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.dmSans(color: Colors.grey),
          prefixIcon: Icon(icon, color: Color(0xFF003876)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Color(0xFF003876), width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: _selectDate,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Color(0xFF003876)),
            SizedBox(width: 10),
            Text(
              _selectedDate != null
                  ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                  : 'Seleccione una fecha',
              style: GoogleFonts.dmSans(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker() {
    return InkWell(
      onTap: _selectTime,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.access_time, color: Color(0xFF003876)),
            SizedBox(width: 10),
            Text(
              _selectedTime != null
                  ? _selectedTime!.format(context)
                  : 'Seleccione una hora',
              style: GoogleFonts.dmSans(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return InkWell(
      onTap: _pickImage,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.camera_alt, color: Color(0xFF003876)),
            SizedBox(width: 10),
            Text(
              _photoPath.isNotEmpty
                  ? 'Foto seleccionada'
                  : 'Seleccione una foto',
              style: GoogleFonts.dmSans(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioRecorder() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nota de voz',
            style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _isRecording ? null : _startRecording,
                icon: Icon(Icons.mic, color: Colors.white),
                label: Text('Grabar', style: GoogleFonts.dmSans(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF003876),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: _isRecording ? _stopRecording : null,
                icon: Icon(Icons.stop, color: Colors.white),
                label: Text('Detener', style: GoogleFonts.dmSans(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            _audioPath.isNotEmpty
                ? 'Nota de voz grabada'
                : 'No se ha grabado una nota de voz',
            style: GoogleFonts.dmSans(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ubicación',
          style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: _getCurrentLocation,
              icon: Icon(Icons.location_on, color: Colors.white),
              label: Text('Obtener ubicación', style: GoogleFonts.dmSans(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF003876),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        _buildTextField(_latitudeController, 'Latitud', Icons.my_location),
        SizedBox(height: 10),
        _buildTextField(_longitudeController, 'Longitud', Icons.my_location),
      ],
    );
  }
}
