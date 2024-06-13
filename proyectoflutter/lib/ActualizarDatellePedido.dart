import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importa esta librería
import 'package:http/http.dart' as http;

class ActualizarDetallePedido extends StatefulWidget {
  final Map<String, dynamic> detallePedido;

  ActualizarDetallePedido({required this.detallePedido});

  @override
  _ActualizarDetallePedidoState createState() => _ActualizarDetallePedidoState();
}

class _ActualizarDetallePedidoState extends State<ActualizarDetallePedido> {
  final _formKey = GlobalKey<FormState>();
  late String nombreProducto;
  late String cantidad;
  late String precioUnitario;

  @override
  void initState() {
    super.initState();
    nombreProducto = widget.detallePedido['nombreProducto'];
    cantidad = widget.detallePedido['cantidad'].toString();
    precioUnitario = widget.detallePedido['precioUnitario'].toString();
  }

  Future<void> actualizarDetallePedido() async {
    final response = await http.put(
      Uri.parse('https://192.168.1.12:7019/api/DetallePedido/${widget.detallePedido['idDetallePedido']}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'idDetallePedido': widget.detallePedido['idDetallePedido'],
        'nombreProducto': nombreProducto,
        'cantidad': int.parse(cantidad),
        'precioUnitario': double.parse(precioUnitario),
        'estatus': 1,
      }),
    );

    if (response.statusCode == 204) {
      Navigator.pop(context);
    } else {
      print('Failed to update detalle pedido. Response: ${response.body}');
      throw Exception('Failed to update detalle pedido');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actualizar detalle pedido'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: nombreProducto,
                decoration: InputDecoration(labelText: 'Nombre del producto'),
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
                initialValue: cantidad,
                decoration: InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor introduzca la cantidad';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    cantidad = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: precioUnitario,
                decoration: InputDecoration(labelText: 'Precio unitario'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor introduzca el precio unitario';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    precioUnitario = value;
                  });
                },
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    actualizarDetallePedido();
                  }
                },
                child: Text('Actualizar detalle pedido'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
