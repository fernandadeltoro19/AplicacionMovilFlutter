import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importar esta librería
import 'package:http/http.dart' as http;

class ActualizarCliente extends StatefulWidget {
  final Map<String, dynamic> cliente;

  ActualizarCliente({required this.cliente});

  @override
  _ActualizarClienteState createState() => _ActualizarClienteState();
}

class _ActualizarClienteState extends State<ActualizarCliente> {
  final _formKey = GlobalKey<FormState>();
  late String nombre;
  late String apellido;
  late String direccion;
  late String telefono;
  late String correo;

  @override
  void initState() {
    super.initState();
    nombre = widget.cliente['nombre'];
    apellido = widget.cliente['apellido'];
    direccion = widget.cliente['direccion'];
    telefono = widget.cliente['telefono'].toString();
    correo = widget.cliente['correo'];
  }

  Future<void> actualizarCliente() async {
    final response = await http.put(
      Uri.parse('https://192.168.1.12:7019/api/Cliente/${widget.cliente['idCliente']}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'idCliente': widget.cliente['idCliente'],
        'nombre': nombre,
        'apellido': apellido,
        'direccion': direccion,
        'telefono': int.parse(telefono),
        'correo': correo,
        'estatus': 1,
      }),
    );

    if (response.statusCode == 204) {
      Navigator.pop(context);
    } else {
      print('Failed to update client. Response: ${response.body}');
      throw Exception('Failed to update client');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actualizar cliente'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: nombre,
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
                initialValue: apellido,
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
                initialValue: direccion,
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
                initialValue: telefono,
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
                initialValue: correo,
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
                    actualizarCliente();
                  }
                },
                child: Text('Actualizar cliente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
