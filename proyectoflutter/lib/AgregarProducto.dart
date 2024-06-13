import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  String nombre = '';
  String descripcion = '';
  double precio = 0.0;
  int stock = 0;

  Future<void> addProduct() async {
    final response = await http.post(
      Uri.parse('https://192.168.1.12:7019/api/Producto'),
      headers: { 'Content-Type': 'application/json' },
      body: json.encode({
        'nombre': nombre,
        'descripcion': descripcion,
        'precio': precio,
        'stock': stock,
        'estatus': 1, 
      }),
    );

    if (response.statusCode == 201) {
      Navigator.pop(context);
    } else {
      print('Failed to add product. Response: ${response.body}');
      throw Exception('Failed to add product');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar un producto'),
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
                decoration: InputDecoration(labelText: 'Descripción'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor introduzca la descripción';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    descripcion = value;
                  });
                },
              ),
              SizedBox(height: 16.0), 
              TextFormField(
                decoration: InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor introduzca el precio';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor introduzca un número válido';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    try {
                      precio = double.parse(value);
                    } catch (e) {
                      print('Error al convertir el valor: $e');
                    }
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor introduzca el valor del stock';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor introduzca un número válido';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    try {
                      stock = int.parse(value);
                    } catch (e) {
                      print('Error al convertir el valor: $e');
                    }
                  });
                },
              ),
              SizedBox(height: 32.0), 
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    addProduct();
                  }
                },
                child: Text('Agregar producto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
