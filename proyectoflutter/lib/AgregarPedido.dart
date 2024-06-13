import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AgregarPedido extends StatefulWidget {
  @override
  _AgregarPedidoState createState() => _AgregarPedidoState();
}

class _AgregarPedidoState extends State<AgregarPedido> {
  final _formKey = GlobalKey<FormState>();
  DateTime? fecha;
  String direccion = '';

  Future<void> agregarPedido() async {
    if (fecha == null) {
      return;
    }

    final formattedDate = DateFormat('yyyy-MM-dd').format(fecha!);

    final response = await http.post(
      Uri.parse('https://192.168.1.12:7019/api/Pedido'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'fecha': formattedDate,
        'direccion': direccion,
        'estatus': 1,
      }),
    );

    if (response.statusCode == 201) {
      Navigator.pop(context);
    } else {
      print('Failed to add pedido. Response: ${response.body}');
      throw Exception('Failed to add pedido');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2025),
    );
    if (pickedDate != null) {
      setState(() {
        fecha = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar un pedido'),
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
                    controller: TextEditingController(
                        text: fecha != null
                            ? DateFormat('yyyy-MM-dd').format(fecha!)
                            : ''),
                  ),
                ),
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
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    agregarPedido();
                  }
                },
                child: Text('Agregar pedido'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
