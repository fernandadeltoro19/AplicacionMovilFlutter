import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ActualizarUsuario extends StatefulWidget {
  final Map<String, dynamic> usuario;

  ActualizarUsuario({required this.usuario});

  @override
  _ActualizarUsuarioState createState() => _ActualizarUsuarioState();
}

class _ActualizarUsuarioState extends State<ActualizarUsuario> {
  final _formKey = GlobalKey<FormState>();
  late String nombreUsuario;
  late String contrasena;
  late String correo;
  late String rol;

  @override
  void initState() {
    super.initState();
    nombreUsuario = widget.usuario['nombreUsuario'];
    contrasena = widget.usuario['contrasena'];
    correo = widget.usuario['correo'];
    rol = widget.usuario['rol'];
  }

  Future<void> actualizarUsuario() async {
    try {
      final response = await http.put(
        Uri.parse('https://192.168.1.12:7019/api/Usuario/${widget.usuario['idUsuario']}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'idUsuario': widget.usuario['idUsuario'],
          'nombreUsuario': nombreUsuario,
          'contrasena': contrasena,
          'correo': correo,
          'rol': rol,
          'estatus': 1,
        }),
      );

      if (response.statusCode == 204) {
        Navigator.pop(context);
      } else {
        print('Failed to edit usuario. Response: ${response.body}');
        throw Exception('Failed to edit usuario. Status Code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actualizar usuario'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: nombreUsuario,
                decoration: InputDecoration(labelText: 'Nombre de usuario'),
                onChanged: (value) {
                  setState(() {
                    nombreUsuario = value;
                  });
                },
              ),
              TextFormField(
                initialValue: contrasena,
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    contrasena = value;
                  });
                },
              ),
              TextFormField(
                initialValue: correo,
                decoration: InputDecoration(labelText: 'Correo'),
                onChanged: (value) {
                  setState(() {
                    correo = value;
                  });
                },
              ),
              TextFormField(
                initialValue: rol,
                decoration: InputDecoration(labelText: 'Rol'),
                onChanged: (value) {
                  setState(() {
                    rol = value;
                  });
                },
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: actualizarUsuario,
                child: Text('Guardar cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
