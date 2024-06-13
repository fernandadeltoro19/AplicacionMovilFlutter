import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditProduct extends StatefulWidget {
  final Map<String, dynamic> product;

  EditProduct({required this.product});

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _formKey = GlobalKey<FormState>();
  late String nombre;
  late String descripcion;
  late double precio;
  late int stock;

  @override
  void initState() {
    super.initState();
    nombre = widget.product['nombre'];
    descripcion = widget.product['descripcion'];
    precio = widget.product['precio'];
    stock = widget.product['stock'];
  }

  Future<void> editProduct() async {
    try {
      final response = await http.put(
        Uri.parse('https://192.168.1.12:7019/api/Producto/${widget.product['idProducto']}'),
        headers: { 'Content-Type': 'application/json' },
        body: json.encode({
          'idProducto': widget.product['idProducto'], 
          'nombre': nombre,
          'descripcion': descripcion,
          'precio': precio,
          'stock': stock,
          'estatus': 1,  
        }),
      );

      if (response.statusCode == 204) {
        Navigator.pop(context);
      } else {
        print('Failed to edit product. Response: ${response.body}');
        throw Exception('Failed to edit product. Status Code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actualizar producto'),
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
                onChanged: (value) {
                  setState(() {
                    nombre = value;
                  });
                },
              ),
              TextFormField(
                initialValue: descripcion,
                decoration: InputDecoration(labelText: 'Descripción'),
                onChanged: (value) {
                  setState(() {
                    descripcion = value;
                  });
                },
              ),
              TextFormField(
                initialValue: precio.toString(),
                decoration: InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
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
              TextFormField(
                initialValue: stock.toString(),
                decoration: InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
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
                onPressed: editProduct,
                child: Text('Guardar cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
