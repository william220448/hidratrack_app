import 'package:hidratrack_app/models/registros_model.dart';
import 'package:hidratrack_app/repository/registro_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Proveedor para obtener los registros desde la API
final registroProvider =
//Recargo la página si ya se había cargado una vez
    FutureProvider.autoDispose<List<RegistrosModel>>((ref) async {
  print("Llamado a la API de registros...");
  final registroRepository = ref.watch(registroRepositoryProvider);
  return registroRepository.getRegistros();
});

// Proveedor para obtener el detalle de un registro por id
final registroDetalleProvider =
    FutureProvider.family.autoDispose<RegistrosModel, int>((ref, id) async {
  final registroRepository = ref.watch(registroRepositoryProvider);
  return registroRepository.getRegistroById(id);
});

// Proveedor del repositorio
final registroRepositoryProvider = Provider<RegistroRepository>((ref) {
  return RegistroRepository();
});
