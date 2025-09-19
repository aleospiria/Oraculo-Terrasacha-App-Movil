import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:oraculo_terrasacha/Servicios/LoginCognitoServicio.dart';
import 'package:oraculo_terrasacha/Screens/LoginScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = 'Usuario'; // Placeholder
  String _selectedAnalisis = 'Opción 1'; // Placeholders para dropdowns
  String _selectedColeccion = 'Opción 1';
  String _selectedIoT = 'Opción 1';
  String _selectedConstructor = 'Opción 1';
  String _selectedConsultas = 'Opción 1';

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try {
      final currentUser = await Amplify.Auth.getCurrentUser();
      setState(() {
        _userName = currentUser.username; // O currentUser.userId si prefieres
      });
    } catch (e) {
      print('Error fetching user: $e');
      setState(() {
        _userName = 'Usuario';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ORACULO'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final authService = LoginCognitoServicio();
              await authService.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hola $_userName, seleccione la opcion deseada para iniciar su analisis',
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24.0),
            // Dropdown 1: Analisis (opciones reales de ejemplo)
            DropdownButton<String>(
              value: _selectedAnalisis,
              isExpanded: true,
              hint: const Text('Analisis'),
              items: <String>['Análisis de suelo', 'Análisis de clima', 'Análisis de cultivo'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedAnalisis = newValue!;
                });
              },
            ),
            const SizedBox(height: 16.0),
            // Dropdown 2: Colección de arboles
            DropdownButton<String>(
              value: _selectedColeccion,
              isExpanded: true,
              hint: const Text('Colección de arboles'),
              items: <String>['Árboles nativos', 'Árboles frutales', 'Árboles ornamentales'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedColeccion = newValue!;
                });
              },
            ),
            const SizedBox(height: 16.0),
            // Dropdown 3: IoT
            DropdownButton<String>(
              value: _selectedIoT,
              isExpanded: true,
              hint: const Text('IoT'),
              items: <String>['Sensores de humedad', 'Sensores de temperatura', 'Dispositivos de riego'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedIoT = newValue!;
                });
              },
            ),
            const SizedBox(height: 16.0),
            // Dropdown 4: Constructor de fórmulas
            DropdownButton<String>(
              value: _selectedConstructor,
              isExpanded: true,
              hint: const Text('Constructor de fórmulas'),
              items: <String>['Fórmula básica', 'Fórmula avanzada', 'Fórmula personalizada'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedConstructor = newValue!;
                });
              },
            ),
            const SizedBox(height: 16.0),
            // Dropdown 5: Consultas
            DropdownButton<String>(
              value: _selectedConsultas,
              isExpanded: true,
              hint: const Text('Consultas'),
              items: <String>['Consulta de datos históricos', 'Consulta de predicciones', 'Consulta de reportes'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedConsultas = newValue!;
                });
              },
            ),
            const Spacer(), // Para el footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    // TODO: Falta crear Screen a Documentacion API
                    debugPrint('Documentación API tocado');
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => DocumentacionScreen()));
                  },
                  child: const Text(
                    'Documentacion API',
                    style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // TODO: Falta crear Screen a Términos y condiciones
                    debugPrint('Términos y condiciones tocado');
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => TerminosScreen()));
                  },
                  child: const Text(
                    'Terminos y condiciones',
                    style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // TODO: Falta crear Screen a Ayuda
                    debugPrint('Ayuda tocado');
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => AyudaScreen()));
                  },
                  child: const Text(
                    'Ayuda',
                    style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0), // Padding al fondo
          ],
        ),
      ),
    );
  }
}