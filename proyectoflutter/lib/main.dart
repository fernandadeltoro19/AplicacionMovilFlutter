import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'menu.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _message = '';

  Future<void> _login() async {
    final String url = 'https://192.168.56.1:7019/api/Usuario';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> users = jsonDecode(response.body);
        final user = users.firstWhere(
          (user) => user['correo'] == _emailController.text && user['contrasena'] == _passwordController.text,
          orElse: () => null,
        );

        if (user != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Menu()),
          );
        } else {
          setState(() {
            _message = 'Credenciales incorrectas';
          });
        }
      } else {
        setState(() {
          _message = 'Error del servidor. Código de estado: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Error de conexión: $e';
      });
    } finally {
      // Limpiar campos de texto y mensaje
      _emailController.clear();
      _passwordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Container(
            width: 300, // Ancho fijo para centrar los campos
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Correo electrónico'),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Contraseña'),
                  obscureText: true,
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Limpiar campos y mensaje antes de iniciar sesión
                    setState(() {
                      _message = '';
                    });
                    _login();
                  },
                  child: Text('Iniciar sesión'),
                ),
                SizedBox(height: 16.0),
                Text(
                  _message,
                  textAlign: TextAlign.center, // Centrar el mensaje
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}