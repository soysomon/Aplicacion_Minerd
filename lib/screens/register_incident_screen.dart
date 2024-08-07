import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'centro_api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'drawer_menu_screen.dart';
import '../models/incident.dart';
import '../providers/incident_provider.dart';

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
  late ZoomDrawerController _drawerController;

  @override
  void initState() {
    super.initState();
    _drawerController = ZoomDrawerController();
    _audioRecorder = FlutterSoundRecorder();
    _initializeRecorder();
    _searchController.addListener(_filterCentros);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _districtController.dispose();
    _descriptionController.dispose();
    _searchController.dispose();
    _audioRecorder?.closeRecorder();
    super.dispose();
  }

  Future<void> _initializeRecorder() async {
    await _requestPermissions();
    await _audioRecorder!.openRecorder();
    setState(() {});
  }

  Future<void> _requestPermissions() async {
    var status = await Permission.microphone.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      await openAppSettings();
    }
    await Permission.storage.request();
  }

  Future<void> _startRecording() async {
    if (_audioRecorder != null && !_audioRecorder!.isRecording) {
      if (await Permission.microphone.isGranted && await Permission.storage.isGranted) {
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = '${tempDir.path}/flutter_sound.aac';
        await _audioRecorder!.startRecorder(
          toFile: tempPath,
          codec: Codec.aacADTS,
        );
        setState(() {
          _audioPath = tempPath;
          _isRecording = true;
        });
      } else {
        await _requestPermissions();
      }
    }
  }

  Future<void> _stopRecording() async {
    if (_audioRecorder != null && _audioRecorder!.isRecording) {
      await _audioRecorder!.stopRecorder();
      setState(() {
        _isRecording = false;
      });
    }
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
    return ZoomDrawer(
      controller: _drawerController,
      menuScreen: DrawerMenuScreen(),
      mainScreen: _buildMainScreen(),
      borderRadius: 24.0,
      showShadow: true,
      angle: 0.0,
      backgroundColor: Colors.grey[300] ?? Colors.grey,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
      openCurve: Curves.fastOutSlowIn,
      closeCurve: Curves.bounceIn,
    );
  }

  Widget _buildMainScreen() {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Color(0xFF003876),
        elevation: 0,
        title: Text('Registrar Incidencia', style: GoogleFonts.dmSans(color: Colors.white)),
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/icon-menu.svg',
            width: 25,
            height: 25,
            color: Colors.white, // Esto cambiará el color del SVG a blanco
          ),
          onPressed: () {
            _drawerController.toggle?.call();
          },
        ),
      ),
      body: SingleChildScrollView(
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
                  _buildTextField(_titleController, 'Título'),
                  SizedBox(height: 15),
                  _buildDropdownButton(),
                  SizedBox(height: 15),
                  if (_isLoading)
                    CircularProgressIndicator()
                  else if (!_isLoading && _centros.isNotEmpty)
                    _buildCentroDropdown(),
                  SizedBox(height: 15),
                  _buildTextField(_districtController, 'Distrito', readOnly: true),
                  SizedBox(height: 15),
                  _buildTextField(_descriptionController, 'Descripción', maxLines: 3),
                  SizedBox(height: 15),
                  _buildDatePicker(),
                  SizedBox(height: 15),
                  _buildImagePickers(),
                  SizedBox(height: 15),
                  _buildAudioRecorder(),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _saveIncident,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        'Guardar Incidencia',
                        style: GoogleFonts.dmSans(
                          fontSize: 18,
                          color: Colors.white, // Esto hará que las letras sean blancas
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool readOnly = false, int maxLines = 1}) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.dmSans(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFF003876)),
        ),
      ),
    );
  }

  Widget _buildDropdownButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButton<String>(
        hint: Text('Seleccione una regional', style: GoogleFonts.dmSans()),
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
            child: Text('Regional $regional', style: GoogleFonts.dmSans()),
          );
        }),
        isExpanded: true,
        underline: SizedBox(),
      ),
    );
  }

  Widget _buildCentroDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButton<Centro>(
        hint: Text('Seleccione un centro', style: GoogleFonts.dmSans()),
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
            child: Text(centro.nombre, style: GoogleFonts.dmSans()),
          );
        }).toList(),
        isExpanded: true,
        underline: SizedBox(),
      ),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: _selectDate,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Fecha',
          labelStyle: GoogleFonts.dmSans(color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedDate == null ? 'Seleccione una fecha' : '${_selectedDate!.toLocal()}'.split(' ')[0],
              style: GoogleFonts.dmSans(),
            ),
            Icon(Icons.calendar_today, color: Color(0xFF003876)),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: Icon(Icons.photo_library, color: Colors.white),
                label: Text('Galería', style: GoogleFonts.dmSans(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF003876),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.camera),
                icon: Icon(Icons.camera_alt, color: Colors.white),
                label: Text('Cámara', style: GoogleFonts.dmSans(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF003876),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _photoPaths.map((path) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(File(path), height: 80, width: 80, fit: BoxFit.cover),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAudioRecorder() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isRecording ? _stopRecording : _startRecording,
            icon: Icon(_isRecording ? Icons.stop : Icons.mic, color: Colors.white),
            label: Text(_isRecording ? 'Detener' : 'Grabar Audio', style: GoogleFonts.dmSans(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isRecording ? Colors.red : Color(0xFF003876),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            _isRecording ? 'Grabando...' : _audioPath.isNotEmpty ? 'Audio Grabado' : 'Sin Audio',
            style: GoogleFonts.dmSans(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
