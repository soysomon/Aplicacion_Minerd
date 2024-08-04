import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/registro_api.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _cedulaController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _cedulaController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _recoverPassword() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String cedula = _cedulaController.text;
      String email = _emailController.text;

      final response = await Provider.of<RegistroApi>(context, listen: false).recuperarClave(
        cedula: cedula,
        correo: email,
      );

      print('Response: $response');

      if (response['exito']) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Se ha enviado un enlace de recuperación a su correo.'),
        ));
        Navigator.of(context).pop();
      } else {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recuperar Contraseña'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Ingrese su cédula y correo para recibir un enlace de recuperación de contraseña.',
              style: GoogleFonts.dmSans(fontSize: 18),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _cedulaController,
              decoration: InputDecoration(
                labelText: 'Cédula',
                labelStyle: GoogleFonts.dmSans(fontSize: 18),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Correo',
                labelStyle: GoogleFonts.dmSans(fontSize: 18),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _recoverPassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                  'Recuperar Contraseña',
                  style: GoogleFonts.dmSans(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
