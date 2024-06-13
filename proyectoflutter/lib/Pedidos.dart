import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'AgregarPedido.dart';
import 'ActualizarPedido.dart';

class Pedidos extends StatefulWidget {
  @override
  _PedidosState createState() => _PedidosState();
}

class _PedidosState extends State<Pedidos> {
  List<dynamic> pedidos = [];

  @override
  void initState() {
    super.initState();
    fetchPedidos();
  }

  Future<void> fetchPedidos() async {
    final response = await http.get(Uri.parse('https://192.168.1.12:7019/api/Pedido'));

    if (response.statusCode == 200) {
      setState(() {
        pedidos = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load pedidos');
    }
  }

  Future<void> deletePedido(int id) async {
    final response = await http.put(Uri.parse('https://192.168.1.12:7019/api/Pedido/$id/CambiarEstatus'));

    if (response.statusCode == 204) {
      setState(() {
        final index = pedidos.indexWhere((pedido) => pedido['idPedido'] == id);
        pedidos[index]['estatus'] = 0;
      });
    } else {
      throw Exception('Failed to delete pedido');
    }
  }

  void confirmDeletePedido(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmación'),
          content: Text('¿Estás seguro de que deseas eliminar este Pedido?'),
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
                deletePedido(id);
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
        title: Text('Lista de pedidos'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AgregarPedido()),
              ).then((value) => fetchPedidos());
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: pedidos.length,
        itemBuilder: (context, index) {
          final pedido = pedidos[index];
          if (pedido['estatus'] == 0) {
            return SizedBox.shrink();
          }
          return Column(
            children: [
              ListTile(
                title: Text('ID Pedido: ${pedido['idPedido']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fecha: ${pedido['fecha']}',
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Dirección: ${pedido['direccion']}',
                      style: TextStyle(fontSize: 12),
                    ),
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
                                ActualizarPedido(pedido: pedido),
                          ),
                        ).then((value) => fetchPedidos());
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () =>
                          confirmDeletePedido(context, pedido['idPedido']),
                    ),
                  ],
                ),
              ),
              if (pedido['estatus'] == 1)
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
