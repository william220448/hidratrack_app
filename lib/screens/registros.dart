import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hidratrack_app/providers/registro_provider.dart';
import 'package:hidratrack_app/screens/detalle_registro.dart';

class RegistrosScreen extends ConsumerWidget {
  const RegistrosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registrosAsync = ref.watch(registroProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registros de Hidratación'),
        centerTitle: true,
        backgroundColor: const Color(0xFF3b2863),
      ),
      body: registrosAsync.when(
        data: (registros) {
          return registros.isNotEmpty
              ? ListView.builder(
                  itemCount: registros.length,
                  itemBuilder: (context, index) {
                    final registro = registros[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: const Icon(Icons.water_drop_rounded,
                            color: Color(0xFF3b2863), size: 30),
                        title: Text(
                          'Cantidad: ${registro.cantidadMl} ml',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                            'Fecha: ${registro.fecha}\nHora: ${registro.hora}'),
                        isThreeLine: true,
                        onTap: () {
                          //Transfiero a detalle
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RegistroDetalleScreen(id: registro.id),
                            ),
                          );
                        },
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text('No hay registros disponibles',
                      style: TextStyle(fontSize: 18)));
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
