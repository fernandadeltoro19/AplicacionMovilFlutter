import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'AgregarCliente.dart';
import 'ActualizarCliente.dart';

class Clientes extends StatefulWidget {
  @override
  _ClientesState createState() => _ClientesState();
}

class _ClientesState extends State<Clientes> {
  List<dynamic> clientes = [];

  @override
  void initState() {
    super.initState();
    fetchClientes();
  }

  Future<void> fetchClientes() async {
    final response = await http.get(Uri.parse('https://192.168.1.12:7019/api/Cliente'));

    if (response.statusCode == 200) {
      setState(() {
        clientes = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load clients');
    }
  }

  Future<void> deleteCliente(int id) async {
    final response = await http.put(Uri.parse('https://192.168.1.12:7019/api/Cliente/$id/CambiarEstatus'));

    if (response.statusCode == 204) {
      setState(() {
        final index = clientes.indexWhere((cliente) => cliente['idCliente'] == id);
        clientes[index]['estatus'] = 0;
      });
    } else {
      throw Exception('Failed to delete client');
    }
  }

  void confirmDeleteCliente(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmación'),
          content: Text('¿Estás seguro de que deseas eliminar este cliente?'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () {
                Navigator.of(context).pop();
                deleteCliente(id);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de clientes'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AgregarCliente()),
              ).then((value) => fetchClientes());
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: clientes.length,
        itemBuilder: (context, index) {
          final cliente = clientes[index];
          if (cliente['estatus'] == 0) {
            return SizedBox.shrink();
          }
          return Column(
            children: [
              ListTile(
                title: Text('${cliente['nombre']} ${cliente['apellido']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Dirección: ${cliente['direccion']}', style: TextStyle(fontSize: 12)),
                    Text('Teléfono: ${cliente['telefono']}', style: TextStyle(fontSize: 12)),
                    Text('Correo: ${cliente['correo']}', style: TextStyle(fontSize: 12)),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ActualizarCliente(cliente: cliente),
                          ),
                        ).then((value) => fetchClientes());
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => confirmDeleteCliente(context, cliente['idCliente']),
                    ),
                  ],
                ),
              ),
              if (cliente['estatus'] == 1)
                Divider(
                  thickness: 1,
                  color: Color.fromARGB(255, 163, 163, 165),
                ),
            ],
          );
        },
      ),
    );
  }
}
