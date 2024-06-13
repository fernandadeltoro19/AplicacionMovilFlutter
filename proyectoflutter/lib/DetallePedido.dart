import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'AgregarDetallePedido.dart';
import 'ActualizarDatellePedido.dart';

class DetallePedido extends StatefulWidget {
  @override
  _DetallePedidoState createState() => _DetallePedidoState();
}

class _DetallePedidoState extends State<DetallePedido> {
  List<dynamic> detallesPedidos = [];

  @override
  void initState() {
    super.initState();
    fetchDetallesPedidos();
  }

  Future<void> fetchDetallesPedidos() async {
    final response = await http.get(Uri.parse('https://192.168.1.12:7019/api/DetallePedido'));

    if (response.statusCode == 200) {
      setState(() {
        detallesPedidos = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load details of orders');
    }
  }

  Future<void> deleteDetallePedido(int id) async {
    final response = await http.put(Uri.parse('https://192.168.1.12:7019/api/DetallePedido/$id/CambiarEstatus'));

    if (response.statusCode == 204) {
      setState(() {
        detallesPedidos.removeWhere((detalle) => detalle['idDetallePedido'] == id);
      });
    } else {
      throw Exception('Failed to delete detail of order');
    }
  }

  void confirmDetallePedido(BuildContext context, int id) {
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
                deleteDetallePedido(id);
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
        title: Text('Detalle de Pedidos'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AgregarDetallePedido()),
              ).then((value) => fetchDetallesPedidos());
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: detallesPedidos.length,
        itemBuilder: (context, index) {
          final detallePedido = detallesPedidos[index];
          if (detallePedido['estatus'] == 0) {
            return SizedBox.shrink();
          }
          return Column(
            children: [
              ListTile(
                title: Text('${detallePedido['idDetallePedido']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Producto: ${detallePedido['nombreProducto']}',
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Cantidad: ${detallePedido['cantidad']}',
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Precio Unitario: ${detallePedido['precioUnitario']}',
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
                                ActualizarDetallePedido(detallePedido: detallePedido),
                          ),
                        ).then((value) => fetchDetallesPedidos());
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => confirmDetallePedido(context, detallePedido['idDetallePedido']),
                    ),
                  ],
                ),
              ),
              if (detallePedido['estatus'] == 1)
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
