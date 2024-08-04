import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sound/flutter_sound.dart';
import '../models/incident.dart';
import '../providers/incident_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'centro_api.dart';

class RegisterIncidentScreen extends StatefulWidget {
  @override
  _RegisterIncidentScreenState createState() => _RegisterIncidentScreenState();
}

class _RegisterIncidentScreenState extends State<RegisterIncidentScreen> {
  final _titleController = TextEditingController();
  final _districtController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _searchController = TextEditingController();
  DateTime? _selectedDate;
  List<String> _photoPaths = [];
  String _audioPath = '';
  FlutterSoundRecorder? _audioRecorder;
  bool _isRecording = false;
  List<Centro> _centros = [];
  List<Centro> _filteredCentros = [];
  Centro? _selectedCentro;
  String? _selectedRegional;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _audioRecorder = FlutterSoundRecorder();
    _openAudioSession();
    _searchController.addListener(_filterCentros);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _districtController.dispose();
    _descriptionController.dispose();
    _searchController.dispose();
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

  Future<void> _fetchCentros() async {
    if (_selectedRegional == null || _selectedRegional!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Por favor seleccione una regional'),
      ));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      List<Centro> centros = await CentroApi().fetchCentros(regional: _selectedRegional!);
      setState(() {
        _centros = centros;
        _filteredCentros = centros;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al cargar centros: $e'),
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterCentros() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCentros = _centros.where((centro) {
        return centro.nombre.toLowerCase().startsWith(query);
      }).toList();
    });
  }

  Future<void> _saveIncident() async {
    if (_titleController.text.isEmpty ||
        _selectedCentro == null ||
        _selectedRegional == null ||
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
      center: _selectedCentro!.nombre,
      regional: _selectedRegional!,
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
            DropdownButton<String>(
              hint: Text('Seleccione una regional'),
              value: _selectedRegional,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRegional = newValue;
                  _fetchCentros();
                });
              },
              items: List.generate(18, (index) {
                String regional = (index + 1).toString().padLeft(2, '0');
                return DropdownMenuItem<String>(
                  value: regional,
                  child: Text('Regional $regional'),
                );
              }),
              isExpanded: true,
            ),
            if (_isLoading)
              CircularProgressIndicator(),
            if (!_isLoading && _centros.isNotEmpty)
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: DropdownButton<Centro>(
                            hint: Text('Seleccione un centro'),
                            value: _selectedCentro,
                            onChanged: (Centro? newValue) {
                              setState(() {
                                _selectedCentro = newValue;
                                _districtController.text = newValue?.distrito ?? '';
                              });
                            },
                            items: _filteredCentros.map((Centro centro) {
                              return DropdownMenuItem<Centro>(
                                value: centro,
                                child: Text(centro.nombre),
                              );
                            }).toList(),
                            isExpanded: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            TextField(
              controller: _districtController,
              decoration: InputDecoration(labelText: 'Distrito'),
              readOnly: true,
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
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              children: [
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  child: Text('Seleccionar Foto'),
                ),
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.camera),
                  child: Text('Tomar Foto'),
                ),
              ],
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
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
