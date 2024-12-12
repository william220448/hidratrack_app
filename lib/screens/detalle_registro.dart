import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hidratrack_app/models/registros_model.dart';
import 'package:hidratrack_app/providers/registro_provider.dart';
import 'package:dio/dio.dart';

class RegistroDetalleScreen extends ConsumerStatefulWidget {
  final int id;

  const RegistroDetalleScreen({super.key, required this.id});

  @override
  _RegistroDetalleScreenState createState() => _RegistroDetalleScreenState();
}

class _RegistroDetalleScreenState extends ConsumerState<RegistroDetalleScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  late TextEditingController _cantidadController;

  @override
  void initState() {
    super.initState();
    _cantidadController = TextEditingController();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final registro = await ref.read(registroDetalleProvider(widget.id).future);
    setState(() {
      selectedDate = DateTime(
        registro.fecha.year,
        registro.fecha.month,
        registro.fecha.day,
      );
      final horaPartes = registro.hora.split(':');
      selectedTime = TimeOfDay(
        hour: int.parse(horaPartes[0]),
        minute: int.parse(horaPartes[1]),
      );
      _cantidadController.text = registro.cantidadMl.toString();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade600,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue.shade600,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade600,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  Future<void> _actualizarRegistro() async {
    final int cantidad = int.tryParse(_cantidadController.text) ?? 0;
    final DateTime? fecha = selectedDate;
    final TimeOfDay? hora = selectedTime;

    if (cantidad == 0 || fecha == null || hora == null) {
      print('Por favor completa todos los campos');
      return;
    }

    final String formattedFecha = '${fecha.year}-${fecha.month}-${fecha.day}';
    final String formattedHora =
        '${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}';

    final data = {
      'id': widget.id,
      'cantidad_ml': cantidad,
      'fecha': formattedFecha,
      'hora': formattedHora,
    };

    try {
      final response = await Dio().post(
        //'http://192.168.137.204:3000/api/hidratacion',
        'http://10.0.2.2:3000/api/hidratacion',
        data: data,
      );

      if (response.data['error'] == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registro actualizado exitosamente')),
        );
      } else {
        print('Error en la respuesta de la API');
      }
    } catch (e) {
      print('Error al conectar con la API: $e');
    }
  }

//Función de eliminar
  Future<void> _eliminarRegistro() async {
    final data = {'id': widget.id};

    try {
      final response = await Dio().put(
        //'http://192.168.137.204:3000/api/hidratacion',
        'http://10.0.2.2:3000/api/hidratacion',
        data: data,
      );

      if (response.data['error'] == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Registro eliminado exitosamente')),
        );
      } else {
        print('Error en la respuesta de la API');
      }
    } catch (e) {
      print('Error al conectar con la API: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Registro'),
        centerTitle: true,
        backgroundColor: const Color(0xFF3b2863),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Center(
                child: Text(
                  "Detalle del Registro",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextField(
                    controller: _cantidadController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Cantidad en ml',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      prefixIcon: const Icon(Icons.local_drink),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                      ),
                    ),
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextField(
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    decoration: InputDecoration(
                      labelText: selectedDate == null
                          ? "Seleccionar fecha"
                          : "Fecha: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      prefixIcon: const Icon(Icons.calendar_today),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                      ),
                    ),
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextField(
                    readOnly: true,
                    onTap: () => _selectTime(context),
                    decoration: InputDecoration(
                      labelText: selectedTime == null
                          ? "Seleccionar hora"
                          : "Hora: ${selectedTime!.hour}:${selectedTime!.minute.toString().padLeft(2, '0')}",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      prefixIcon: const Icon(Icons.watch_later),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                      ),
                    ),
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed:
                      //Uso la función actualizar
                      _actualizarRegistro,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 16.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    "Actualizar",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              //Botón para eliminar
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _eliminarRegistro,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 228, 19, 19),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 16.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    "Eliminar",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
