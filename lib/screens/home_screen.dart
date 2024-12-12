import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'registros.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Guardo hora y fecha
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  //Guardo los ml
  final TextEditingController _cantidadController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
      initialTime: TimeOfDay.now(),
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

  // Función para el botón de registrar
  Future<void> _registrar() async {
    final int? cantidad = int.tryParse(_cantidadController.text);
    final DateTime? fecha = selectedDate;
    final TimeOfDay? hora = selectedTime;

    if (cantidad == null || fecha == null || hora == null) {
      print('Por favor completa todos los campos');
      return;
    }
    print('Cantidad: $cantidad');
    print('Fecha: $fecha');
    print('Hora: $hora');

    final String formattedFecha = '${fecha.year}-${fecha.month}-${fecha.day}';
    final String formattedHora =
        '${hora.hour}:${hora.minute.toString().padLeft(2, '0')}';

    final data = {
      'id': 0,
      'cantidad_ml': cantidad,
      'fecha': formattedFecha,
      'hora': formattedHora,
    };

    try {
      /*
      final response = await Dio().post(
        'http://192.168.100.6:3000/api/hidratacion',
        data: data,
      );
      */
      final response = await Dio().post(
        'http://10.0.2.2:3000/api/hidratacion',
        data: data,
      );

      if (response.data['error'] == false) {
        // Manejo de la respuesta exitosa
        print('Registro guardado exitosamente');
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
        leading: Padding(
          // Pongo espacio alrededor del logo
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('imagenes/logo.png'),
        ),
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: "Hidra",
                style: TextStyle(
                  color: Color.fromARGB(255, 11, 127, 223),
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              TextSpan(
                text: "Track",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 30,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFDBE6E7),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Espacio
              const SizedBox(height: 16),
              Center(
                child: Text(
                  "Bienvenido a HidraTrack",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // Separo esta sección
              const SizedBox(height: 24),
              Center(
                child: Text(
                  "¿Has bebido agua hoy?",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              TextField(
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

              // Selector de fecha
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextField(
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    decoration: InputDecoration(
                      hintText: selectedDate == null
                          ? "Seleccionar fecha"
                          : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
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
              // Selector de hora
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextField(
                    readOnly: true,
                    onTap: () => _selectTime(context),
                    decoration: InputDecoration(
                      hintText: selectedTime == null
                          ? "Seleccionar hora"
                          : "${selectedTime!.hour}:${selectedTime!.minute.toString().padLeft(2, '0')}",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botón registrar
                  ElevatedButton(
                    onPressed: _registrar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B2863),
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
                      "Registrar",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  // Botón para ver el historial
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegistrosScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
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
                      "Ver historial",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
