import 'package:hidratrack_app/models/registros_model.dart';
import 'package:dio/dio.dart';

class RegistroRepository {
  final Dio _dio = Dio();

  Future<List<RegistrosModel>> getRegistros() async {
    String url = "http://10.0.2.2:3000/api/hidratacion";
    //Enlace para celular
    //String url = "http://192.168.100.6:3000/api/hidratacion";

    try {
      // GET
      Response response = await _dio.get(url);

      if (response.data['error'] == false) {
        List<dynamic> body = response.data['body'];
        return body.map((json) => RegistrosModel.fromJson(json)).toList();
      } else {
        throw Exception('Error en la respuesta de la API');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error al conectar con la API');
    }
  }

  Future<RegistrosModel> getRegistroById(int id) async {
    String url = "http://10.0.2.2:3000/api/hidratacion/$id";
    //Enlace para celular
    //String url = "http://192.168.100.6:3000/api/hidratacion/$id";

    try {
      // GET
      Response response = await _dio.get(url);

      if (response.data['error'] == false) {
        List<dynamic> body = response.data['body'];
        if (body.isNotEmpty) {
          return RegistrosModel.fromJson(body[0]);
        } else {
          throw Exception('Registro no encontrado');
        }
      } else {
        throw Exception('Error en la respuesta de la API');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error al conectar con la API');
    }
  }
}
