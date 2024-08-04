import 'package:aplicacion_minerd/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importar shared_preferences
import '../providers/registro_api.dart';
import 'register_visit_screen.dart'; // Asegúrate de que este archivo exista
import 'change_password_screen.dart';
import 'forgot_password_screen.dart'; // Nueva importación

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _cedulaController = TextEditingController();
  final _claveController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _cedulaController.dispose();
    _claveController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String cedula = _cedulaController.text;
      String clave = _claveController.text;

      final response = await Provider.of<RegistroApi>(context, listen: false).iniciarSesion(
        cedula: cedula,
        clave: clave,
      );

      print('Response: $response'); // Agregar impresión para depuración

      if (response['exito']) {
        final datos = response['datos'];
        if (datos == null || datos['id'] == null || datos['nombre'] == null || datos['apellido'] == null || datos['correo'] == null || datos['telefono'] == null || datos['fecha_nacimiento'] == null || datos['token'] == null) {
          print('Datos incompletos: $datos');
          throw Exception('Datos incompletos en la respuesta');
        }

        final user = User(
          id: int.parse(datos['id'].toString()),
          name: datos['nombre'].toString(),
          lastName: datos['apellido'].toString(),
          email: datos['correo'].toString(),
          phone: datos['telefono'].toString(),
          birthDate: datos['fecha_nacimiento'].toString(),
          token: datos['token'].toString(),
        );

        Provider.of<UserProvider>(context, listen: false).setUser(user);

        // Guardar el token en SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', user.token);

        // Navigate to home screen
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        // Mostrar mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response['mensaje']),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
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
            height: MediaQuery.of(context).size.height * 0.35, // Ajusta la altura para incluir el texto
            decoration: BoxDecoration(
              color: Color(0xFF003876),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/custom_icon.svg',
                      width: 100,
                      height: 100,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Alinea los textos a la izquierda
                  children: [
                    Text(
                      'GOBIERNO DE LA',
                      style: GoogleFonts.dmSans(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'REPÚBLICA DOMINICANA',
                      style: GoogleFonts.radley(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'EDUCACIÓN',
                      style: GoogleFonts.radley(
                        fontSize: 20,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 30),
                    Text(
                      'Login',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dmSans(
                        fontSize: 32,
                        fontWeight: FontWeight.normal,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
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
                              contentPadding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                            ),
                          ),
                          SizedBox(height: 30),
                          TextField(
                            controller: _claveController,
                            obscureText: true,
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
                              contentPadding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                            ),
                          ),
                          SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                                );
                              },
                              child: Text(
                                '¿Olvidaste tu contraseña?',
                                style: GoogleFonts.poppins(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
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
                                  'Login',
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
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => RegisterScreen()),
                              );
                            },
                            child: Text(
                              "¿No tiene cuenta? Regístrese",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
                              );
                            },
                            child: Text(
                              "¿Ha olvidado su contraseña? Cámbiela aquí",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
