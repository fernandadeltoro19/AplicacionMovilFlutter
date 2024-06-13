import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ActualizarCategoria extends StatefulWidget {
  final Map<String, dynamic> categoria;

  ActualizarCategoria({required this.categoria});

  @override
  _ActualizarCategoriaState createState() => _ActualizarCategoriaState();
}

class _ActualizarCategoriaState extends State<ActualizarCategoria> {
  final _formKey = GlobalKey<FormState>();
  late String nombre;

  @override
  void initState() {
    super.initState();
    nombre = widget.categoria['nombre'];
  }

  Future<void> actualizarCategoria() async {
    try {
      final response = await http.put(
        Uri.parse('https://192.168.1.12:7019/api/Categoria/${widget.categoria['idCategoria']}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'idCategoria': widget.categoria['idCategoria'],
          'nombre': nombre,
          'estatus': 1,
        }),
      );

      if (response.statusCode == 204) {
        Navigator.pop(context);
      } else {
        print('Failed to edit category. Response: ${response.body}');
        throw Exception('Failed to edit category. Status Code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actualizar categoría'),
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
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: actualizarCategoria,
                child: Text('Guardar cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
