import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ActualizarPedido extends StatefulWidget {
  final Map<String, dynamic> pedido;

  ActualizarPedido({required this.pedido});

  @override
  _ActualizarPedidoState createState() => _ActualizarPedidoState();
}

class _ActualizarPedidoState extends State<ActualizarPedido> {
  final _formKey = GlobalKey<FormState>();
  late String fecha;
  late String direccion;

  @override
  void initState() {
    super.initState();
    fecha = widget.pedido['fecha'];
    direccion = widget.pedido['direccion'];
  }

  Future<void> actualizarPedido() async {
    try {
      final response = await http.put(
        Uri.parse('https://192.168.1.12:7019/api/Pedido/${widget.pedido['idPedido']}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'idPedido': widget.pedido['idPedido'], 
          'fecha': fecha,
          'direccion': direccion,
          'estatus': 1,  
        }),
      );

      if (response.statusCode == 204) {
        Navigator.pop(context);
      } else {
        print('Failed to edit pedido. Response: ${response.body}');
        throw Exception('Failed to edit pedido. Status Code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2025),
    );
    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        fecha = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actualizar pedido'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Fecha',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor seleccione la fecha';
                      }
                      return null;
                    },
                    controller: TextEditingController(text: fecha),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: direccion,
                decoration: InputDecoration(labelText: 'Dirección'),
                onChanged: (value) {
                  setState(() {
                    direccion = value;
                  });
                },
              ),
              SizedBox(height: 32.0), 
              ElevatedButton(
                onPressed: actualizarPedido,
                child: Text('Guardar cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
