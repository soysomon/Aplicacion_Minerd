import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/registro_api.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _tokenController = TextEditingController();
  final _claveAnteriorController = TextEditingController();
  final _claveNuevaController = TextEditingController();
  bool _isLoading = false;

  Future<void> _changePassword() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await Provider.of<RegistroApi>(context, listen: false).cambiarClave(
        token: _tokenController.text,
        claveAnterior: _claveAnteriorController.text,
        claveNueva: _claveNuevaController.text,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cambiar Clave'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tokenController,
              decoration: InputDecoration(labelText: 'Token'),
            ),
            TextField(
              controller: _claveAnteriorController,
              decoration: InputDecoration(labelText: 'Clave Anterior'),
              obscureText: true,
            ),
            TextField(
              controller: _claveNuevaController,
              decoration: InputDecoration(labelText: 'Clave Nueva'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _changePassword,
              child: Text('Cambiar Clave'),
            ),
          ],
        ),
      ),
    );
  }
}
