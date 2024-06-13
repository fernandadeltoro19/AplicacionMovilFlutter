import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'RegistroUsuario.dart';
import 'ActualizarUsuario.dart';

class Usuario extends StatefulWidget {
  @override
  _UsuarioState createState() => _UsuarioState();
}

class _UsuarioState extends State<Usuario> {
  List<dynamic> usuarios = [];

  @override
  void initState() {
    super.initState();
    fetchUsuarios();
  }

  Future<void> fetchUsuarios() async {
    final response =
        await http.get(Uri.parse('https://192.168.1.12:7019/api/Usuario'));

    if (response.statusCode == 200) {
      setState(() {
        usuarios = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load usuarios');
    }
  }

  void deleteUsuario(int id) async {
    final response = await http
        .delete(Uri.parse('https://192.168.1.12:7019/api/Usuario/$id'));

    if (response.statusCode == 204) {
      setState(() {
        usuarios.removeWhere((usuario) => usuario['idUsuario'] == id);
      });
    } else {
      throw Exception('Failed to delete usuario');
    }
  }

  void confirmDeleteUsuario(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmación'),
          content: Text('¿Estás seguro de que deseas eliminar este usuario?'),
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
                deleteUsuario(id);
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
        title: Text('Lista de usuarios'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegistroUsuario()),
              ).then((value) => fetchUsuarios());
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: usuarios.length,
        itemBuilder: (context, index) {
          final usuario = usuarios[index];
          if (usuario['estatus'] == 0) {
            return SizedBox.shrink();
          }
          return Column(
            children: [
              ListTile(
                title: Text(usuario['nombreUsuario']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Correo: ${usuario['correo']}',
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Rol: ${usuario['rol']}',
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
                                ActualizarUsuario(usuario: usuario),
                          ),
                        ).then((value) => fetchUsuarios());
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () =>
                          confirmDeleteUsuario(context, usuario['idUsuario']),
                    ),
                  ],
                ),
              ),
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
