import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    // Credenciales válidas
    String validUsername = 'user';
    String validPassword = 'admin';

    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username == validUsername && password == validPassword) {
      final user = User(
        id: 1,
        name: 'John',
        lastName: 'Doe',
        registrationNumber: '123456',
        photoUrl: 'https://example.com/photo.jpg',
      );

      Provider.of<UserProvider>(context, listen: false).setUser(user);

      // Navigate to home screen
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Credenciales inválidas'),
      ));
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
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Email',
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
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
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
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8, // Ajusta este valor para controlar el ancho del botón
                            child: ElevatedButton(
                              onPressed: _login,
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
                                child: Text(
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
                          SizedBox(height: 20), // Espacio entre el botón y los iconos
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: FaIcon(FontAwesomeIcons.facebook, color: Colors.black),
                                onPressed: () {
                                  // Navegar a Facebook
                                  launchUrl('https://www.facebook.com/ministerioeducacionrd');
                                },
                              ),
                              SizedBox(width: 20), // Espacio entre los iconos
                              IconButton(
                                icon: FaIcon(FontAwesomeIcons.instagram, color: Colors.black),
                                onPressed: () {
                                  // Navegar a Instagram
                                  launchUrl('https://www.instagram.com/educacionrd/');
                                },
                              ),
                              SizedBox(width: 20), // Espacio entre los iconos
                              IconButton(
                                icon: FaIcon(FontAwesomeIcons.globe, color: Colors.black),
                                onPressed: () {
                                  // Navegar a la web
                                  launchUrl('https://www.ministeriodeeducacion.gob.do/');
                                },
                              ),
                            ],
                          ),

                          SizedBox(height: 80),
                          TextButton(
                            onPressed: () {
                              // Acción para registrarse
                            },
                            child: Text(
                              "Don't have any account? Sign Up",
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
