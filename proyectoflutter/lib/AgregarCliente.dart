import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class AgregarCliente extends StatefulWidget {
  @override
  _AgregarClienteState createState() => _AgregarClienteState();
}

class _AgregarClienteState extends State<AgregarCliente> {
  final _formKey = GlobalKey<FormState>();
  String nombre = '';
  String apellido = '';
  String direccion = '';
  String telefono = '';
  String correo = '';

  Future<void> agregarCliente() async {
    final response = await http.post(
      Uri.parse('https://192.168.1.12:7019/api/Cliente'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nombre': nombre,
        'apellido': apellido,
        'direccion': direccion,
        'telefono': int.parse(telefono),
        'correo': correo,
        'estatus': 1, // Enviar estatus como int
      }),
    );

    if (response.statusCode == 201) {
      Navigator.pop(context);
    } else {
      print('Failed to add client. Response: ${response.body}');
      throw Exception('Failed to add client');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar un cliente'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor introduzca el nombre';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    nombre = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Apellido'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor introduzca el apellido';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    apellido = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Dirección'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor introduzca la dirección';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    direccion = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Teléfono'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor introduzca el teléfono';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    telefono = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Correo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor introduzca el correo';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    correo = value;
                  });
                },
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    agregarCliente();
                  }
                },
                child: Text('Agregar cliente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
