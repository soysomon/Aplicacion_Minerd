import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/registro_api.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _cedulaController = TextEditingController();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _claveController = TextEditingController();
  final _correoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _fechaNacimientoController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _cedulaController.dispose();
    _nombreController.dispose();
    _apellidoController.dispose();
    _claveController.dispose();
    _correoController.dispose();
    _telefonoController.dispose();
    _fechaNacimientoController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await Provider.of<RegistroApi>(context, listen: false).registrarTecnico(
        cedula: _cedulaController.text,
        nombre: _nombreController.text,
        apellido: _apellidoController.text,
        clave: _claveController.text,
        correo: _correoController.text,
        telefono: _telefonoController.text,
        fechaNacimiento: _fechaNacimientoController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['mensaje'])),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF003876), // Fondo azul
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.25, // Ajusta la altura para incluir el texto
            decoration: BoxDecoration(
              color: Color(0xFF003876),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/custom_icon.svg',
                      width: 80,
                      height: 80,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Alinea los textos a la izquierda
                  children: [
                    Text(
                      'GOBIERNO DE LA',
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'REPÚBLICA DOMINICANA',
                      style: GoogleFonts.radley(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'EDUCACIÓN',
                      style: GoogleFonts.radley(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFFAFAFA),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(0),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Registro de Técnico',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                          fontSize: 28,
                          fontWeight: FontWeight.normal,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _cedulaController,
                        decoration: InputDecoration(
                          labelText: 'Cédula',
                          labelStyle: GoogleFonts.dmSans(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _nombreController,
                        decoration: InputDecoration(
                          labelText: 'Nombre',
                          labelStyle: GoogleFonts.dmSans(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _apellidoController,
                        decoration: InputDecoration(
                          labelText: 'Apellido',
                          labelStyle: GoogleFonts.dmSans(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _claveController,
                        decoration: InputDecoration(
                          labelText: 'Clave',
                          labelStyle: GoogleFonts.dmSans(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _correoController,
                        decoration: InputDecoration(
                          labelText: 'Correo',
                          labelStyle: GoogleFonts.dmSans(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _telefonoController,
                        decoration: InputDecoration(
                          labelText: 'Teléfono',
                          labelStyle: GoogleFonts.dmSans(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _fechaNacimientoController,
                        decoration: InputDecoration(
                          labelText: 'Fecha de Nacimiento',
                          labelStyle: GoogleFonts.dmSans(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _fechaNacimientoController.text = "${pickedDate.toLocal()}".split(' ')[0];
                            });
                          }
                        },
                      ),
                      SizedBox(height: 30),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: _isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                              'Crear cuenta',
                              style: GoogleFonts.dmSans(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.facebook, color: Colors.black),
                            onPressed: () {
                              launchUrl('https://www.facebook.com/ministerioeducacionrd');
                            },
                          ),
                          SizedBox(width: 20),
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.instagram, color: Colors.black),
                            onPressed: () {
                              launchUrl('https://www.instagram.com/educacionrd/');
                            },
                          ),
                          SizedBox(width: 20),
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.globe, color: Colors.black),
                            onPressed: () {
                              launchUrl('https://www.ministeriodeeducacion.gob.do/');
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
