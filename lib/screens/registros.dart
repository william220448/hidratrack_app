import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegistrosScreen extends StatelessWidget {
  const RegistrosScreen({super.key});

  Future<String> fetchRegistros() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/hidratacion'),
      );

      if (response.statusCode == 200) {
        // Uso el JSON como texto
        return response.body;
      } else {
        throw Exception(
            'Error al cargar los registros: ${response.statusCode}');
      }
    } catch (e) {
      return 'Error al conectar con la API: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registros de Hidratación'),
        centerTitle: true,
        backgroundColor: const Color(0xFF3b2863),
      ),
      body: FutureBuilder<String>(
        future: fetchRegistros(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              // Logo de cargando
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                // EL json por el momento es texto estático
                child: Text(
                  snapshot.data!,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            );
          } else {
            return const Center(
              child: Text('No hay datos disponibles'),
            );
          }
        },
      ),
    );
  }
}
