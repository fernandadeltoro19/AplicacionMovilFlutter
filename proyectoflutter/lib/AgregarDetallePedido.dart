import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AgregarDetallePedido extends StatefulWidget {
  @override
  _AgregarDetallePedidoState createState() => _AgregarDetallePedidoState();
}

class _AgregarDetallePedidoState extends State<AgregarDetallePedido> {
  final _formKey = GlobalKey<FormState>();
  String nombreProducto = '';
  int cantidad = 0;
  double precioUnitario = 0.0;

  Future<void> agregarDetallePedido() async {
    final response = await http.post(
      Uri.parse('https://192.168.1.12:7019/api/DetallePedido'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nombreProducto': nombreProducto,
        'cantidad': cantidad,
        'precioUnitario': precioUnitario,
        'estatus': 1,
      }),
    );

    if (response.statusCode == 201) {
      Navigator.pop(context);
    } else {
      print('Failed to add detail of order. Response: ${response.body}');
      throw Exception('Failed to add detail of order');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar un detalle de pedido'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nombre del Producto'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor introduzca el nombre del producto';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    nombreProducto = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor introduzca la cantidad';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    cantidad = int.tryParse(value) ?? 0;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Precio Unitario'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor introduzca el precio unitario';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    precioUnitario = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    agregarDetallePedido();
                  }
                },
                child: Text('Agregar detalle de pedido'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
