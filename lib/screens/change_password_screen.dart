import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/registro_api.dart';
import '../providers/user_provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _claveAnteriorController = TextEditingController();
  final _claveNuevaController = TextEditingController();
  final _confirmarClaveNuevaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) {
      return; // Si el formulario no es válido, no continúes.
    }

    if (_claveNuevaController.text != _confirmarClaveNuevaController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Las nuevas contraseñas no coinciden')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final user = Provider.of<UserProvider>(context, listen: false).user;
    print(user.token);

    try {
      final response =
          await Provider.of<RegistroApi>(context, listen: false).cambiarClave(
        token: user.token,
        claveAnterior: _claveAnteriorController.text,
        claveNueva: _claveNuevaController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['mensaje'])),
      );

      // Limpiar los campos de entrada
      if (response['exito']) {
        _claveAnteriorController.clear();
        _claveNuevaController.clear();
        _confirmarClaveNuevaController.clear();
      }
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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _claveAnteriorController,
                decoration: InputDecoration(
                  labelText: 'Clave actual',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su clave actual';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _claveNuevaController,
                decoration: InputDecoration(
                  labelText: 'Clave nueva',
                  prefixIcon: Icon(Icons.lock_open),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su nueva clave';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _confirmarClaveNuevaController,
                decoration: InputDecoration(
                  labelText: 'Confirmar nueva clave',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor confirme su nueva clave';
                  }
                  if (value != _claveNuevaController.text) {
                    return 'Las nuevas contraseñas no coinciden';
                  }
                  return null;
                },
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
      ),
    );
  }
}
