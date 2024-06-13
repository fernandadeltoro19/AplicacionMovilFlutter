import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'AgregarProducto.dart';
import 'ActualizarProducto.dart';

class Producto extends StatefulWidget {
  @override
  _ProductoState createState() => _ProductoState();
}

class _ProductoState extends State<Producto> {
  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response =
        await http.get(Uri.parse('https://192.168.1.12:7019/api/Producto'));

    if (response.statusCode == 200) {
      setState(() {
        products = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  void deleteProduct(int id) async {
    final response = await http
        .delete(Uri.parse('https://192.168.1.12:7019/api/Producto/$id'));

    if (response.statusCode == 204) {
      setState(() {
        products.removeWhere((product) => product['idProducto'] == id);
      });
    } else {
      throw Exception('Failed to delete product');
    }
  }

  void confirmDeleteProduct(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmación'),
          content: Text('¿Estás seguro de que deseas eliminar este producto?'),
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
                deleteProduct(id);
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
        title: Text('Lista de productos'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProduct()),
              ).then((value) => fetchProducts());
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          if (product['estatus'] == 0) {
            return SizedBox.shrink();
          }
          return Column(
            children: [
              ListTile(
                title: Text(product['nombre']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Descripción: ${product['descripcion']}',
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Precio: ${product['precio']}',
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Stock: ${product['stock']}',
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
                                EditProduct(product: product),
                          ),
                        ).then((value) => fetchProducts());
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () =>
                          confirmDeleteProduct(context, product['idProducto']),
                    ),
                  ],
                ),
              ),
              if (product['estatus'] == 1)
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
