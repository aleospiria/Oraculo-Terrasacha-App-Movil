import 'package:flutter/material.dart';
import 'package:oraculo_terrasacha/Modelos/ConsultaProyectoResponse.dart';
import 'package:oraculo_terrasacha/servicios/Apis_terrasacha.dart';

class ConsultaScreen extends StatefulWidget {
  const ConsultaScreen({super.key});

  @override
  _ConsultaScreenState createState() => _ConsultaScreenState();
}

class _ConsultaScreenState extends State<ConsultaScreen> {
  // 1. Controladores para los campos de entrada
  final TextEditingController _projectIDController = TextEditingController();
  final TextEditingController _cedulaCatastralController = TextEditingController();

  // Variable para almacenar el resultado de la consulta
  Future<ConsultaProyectoResponse>? _futureConsulta;

  // Variable para mostrar mensajes de error o éxito
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    // se puede pre-llenar los campos con los valores de ejemplo
    _projectIDController.text = 'WAO-438b-78Y568';
    _cedulaCatastralController.text = '632720000000000010644000000000';
  }

  @override
  //Función para liberar los controladores cuando el widget se destruye
  void dispose() {
    _projectIDController.dispose();
    _cedulaCatastralController.dispose();
    super.dispose();
  }

  // Función para realizar la consulta cuando se presiona el botón
  void _performConsulta() {
    setState(() {
      _statusMessage = 'Realizando consulta...';
      _futureConsulta = ApiService.realizarConsultaProyecto(
        projectID: _projectIDController.text,
        cedulaCatastral: _cedulaCatastralController.text.isEmpty ? null : _cedulaCatastralController.text,
      ) as Future<ConsultaProyectoResponse>?;
    });

    // Manejar el resultado para actualizar el mensaje de estado
    _futureConsulta!.then((response) {
      setState(() {
        _statusMessage = 'Consulta exitosa: ${response.message}';
      });
    }).catchError((error) {
      setState(() {
        _statusMessage = 'Error en la consulta: ${error.toString()}';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta de Proyecto'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView( // Permite hacer scroll si el contenido es muy largo
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Estira los elementos horizontalmente
          children: <Widget>[
            // Input para Project ID
            TextField(
              controller: _projectIDController,
              decoration: const InputDecoration(
                labelText: 'Project ID (Requerido)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0), // Espacio entre elementos

            // Input para Cédula Catastral
            TextField(
              controller: _cedulaCatastralController,
              decoration: const InputDecoration(
                labelText: 'Cédula Catastral (Opcional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24.0),

            // Botón para realizar la consulta
            ElevatedButton(
              onPressed: _performConsulta, // Llama a nuestra función al presionar
              child: const Text('Realizar Consulta'),
            ),
            const SizedBox(height: 24.0),

            // Mostrar el mensaje de estado
            Text(
              _statusMessage,
              style: TextStyle(
                color: _statusMessage.startsWith('Error') ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24.0),

            // FutureBuilder para mostrar los resultados de la API
            _futureConsulta == null
                ? const Text('Presiona "Realizar Consulta" para ver los resultados.')
                : FutureBuilder<ConsultaProyectoResponse>(
              future: _futureConsulta,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error al obtener datos: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Resultados de la Consulta:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8.0),
                      Text('Mensaje: ${snapshot.data!.message}'),
                      Text('Project ID: ${snapshot.data!.projectID}'),
                      Text('Cédula Catastral: ${snapshot.data!.cedulaCatastral}'),
                        Text('Fecha y Hora: ${snapshot.data!.fechaHoraConsulta.toLocal()}'),
                    ],
                  );
                } else {
                  return const Text('No hay datos disponibles.');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}