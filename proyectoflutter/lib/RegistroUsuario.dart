import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro',
      home: RegistroUsuario(),
    );
  }
}

class RegistroUsuario extends StatefulWidget {
  @override
  _RegistroUsuarioState createState() => _RegistroUsuarioState();
}

class _RegistroUsuarioState extends State<RegistroUsuario> {
  final _nombreUsuarioController = TextEditingController();
  final _contrasenaController = TextEditingController();
  final _correoController = TextEditingController();
  final _rolController = TextEditingController();

  String _connectionMessage = '';
  bool _isButtonDisabled = false; // Estado para controlar la habilitación del botón

  Future<void> _registrarUsuario() async {
    final String url = 'https://192.168.1.12:7019/api/Usuario';

    if (_nombreUsuarioController.text.isEmpty ||
        _contrasenaController.text.isEmpty ||
        _correoController.text.isEmpty ||
        _rolController.text.isEmpty) {
      setState(() {
        _connectionMessage = 'Todos los campos son obligatorios';
      });
      return;
    }

    setState(() {
      _isButtonDisabled = true; // Deshabilitar el botón al hacer clic
    });

    try {
      final Map<String, dynamic> requestBody = {
        'nombreUsuario': _nombreUsuarioController.text,
        'contrasena': _contrasenaController.text,
        'correo': _correoController.text,
        'rol': _rolController.text,
        'estatus': 1,
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        Navigator.pop(context, true); // Regresar a la lista de usuarios y actualizarla
      } else if (response.statusCode == 400) {
        setState(() {
          _connectionMessage = 'El correo electrónico ya está registrado';
          _isButtonDisabled = false; // Habilitar el botón después del error
        });
      } else {
        setState(() {
          _connectionMessage = 'Error al registrar usuario';
          _isButtonDisabled = false; // Habilitar el botón después del error
        });
        print('Error en la conexión: ${response.body}');
      }
    } catch (e) {
      setState(() {
        _connectionMessage = 'No se pudo conectar a la API';
        _isButtonDisabled = false; // Habilitar el botón después del error
      });
      print('Error en la conexión: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar un Usuario'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _nombreUsuarioController,
              decoration: InputDecoration(labelText: 'Nombre de usuario'),
            ),
            TextField(
              controller: _contrasenaController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            TextField(
              controller: _correoController,
              decoration: InputDecoration(labelText: 'Correo electrónico'),
            ),
            TextField(
              controller: _rolController,
              decoration: InputDecoration(labelText: 'Rol'),
            ),
            SizedBox(height: 16.0),
            Text(_connectionMessage, style: TextStyle(color: Colors.red)), // Mostrar mensaje de error en rojo
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isButtonDisabled ? null : _registrarUsuario, // Deshabilitar el botón si está procesando
              child: Text('Crear usuario'),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
