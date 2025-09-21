import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:oraculo_terrasacha/Servicios/LoginCognitoServicio.dart';
import 'package:oraculo_terrasacha/Screens/LoginScreen.dart';
import 'package:oraculo_terrasacha/Screens/SeleccionRapidaImagenesScreen.dart';  // Agrega este import para la screen

// TODO: Agrega imports para otras screens cuando las crees (ej. SeleccionManualScreen, etc.)

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = 'Usuario'; // Placeholder
  String? _selectedAnalisis; // Inicial null para empezar con hint
  String? _selectedColeccion;
  String? _selectedIoT;
  String? _selectedConstructor;
  String? _selectedConsultas;

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
            // Dropdown 1: Análisis
            DropdownButton<String>(
              value: _selectedAnalisis,
              isExpanded: true,
              hint: const Text('Análisis'),
              items: <String>['Selección Rápida de Imágenes', 'Selección Manual de Imágenes', 'Análisis con Machine Learning'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedAnalisis = newValue;
                });
                if (newValue != null) {
                  switch (newValue) {
                    case 'Selección Rápida de Imágenes':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SeleccionRapidaImagenesScreen()),
                      );
                      break;
                    case 'Selección Manual de Imágenes':
                    // TODO: Navega a SeleccionManualImagenesScreen
                      debugPrint('$newValue seleccionado');
                      break;
                    case 'Análisis con Machine Learning':
                    // TODO: Navega a AnalisisMLScreen
                      debugPrint('$newValue seleccionado');
                      break;
                  }
                }
              },
            ),
            const SizedBox(height: 16.0),
            // Dropdown 2: Colección de arboles (mantenido como dropdown, con placeholder item)
            DropdownButton<String>(
              value: _selectedColeccion,
              isExpanded: true,
              hint: const Text('Colección de arboles'),
              items: <String>['Iniciar Colección'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedColeccion = newValue;
                });
                if (newValue != null) {
                  // TODO: Navega a screen de Colección de arboles
                  debugPrint('$newValue seleccionado');
                }
              },
            ),
            const SizedBox(height: 16.0),
            // Dropdown 3: IoT
            DropdownButton<String>(
              value: _selectedIoT,
              isExpanded: true,
              hint: const Text('IoT'),
              items: <String>['Conexión IoT', 'Dashboard IoT(BETA)'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedIoT = newValue;
                });
                if (newValue != null) {
                  // TODO: Navega a screen correspondiente
                  debugPrint('$newValue seleccionado');
                }
              },
            ),
            const SizedBox(height: 16.0),
            // Dropdown 4: Constructor de Formulas
            DropdownButton<String>(
              value: _selectedConstructor,
              isExpanded: true,
              hint: const Text('Constructor de Formulas'),
              items: <String>['Alométricas - Variables', 'Alométricas - Constructor', 'Alométricas - Biblioteca', 'Alométricas - Pruebas', 'Teledetección', 'Modelos ML', 'Biblioteca General'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedConstructor = newValue;
                });
                if (newValue != null) {
                  // TODO: Navega a screen correspondiente
                  debugPrint('$newValue seleccionado');
                }
              },
            ),
            const SizedBox(height: 16.0),
            // Dropdown 5: Consultas
            DropdownButton<String>(
              value: _selectedConsultas,
              isExpanded: true,
              hint: const Text('Consultas'),
              items: <String>['Imágenes Satelitales Exportadas', 'Consultas API', 'Historial de Consultas'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedConsultas = newValue;
                });
                if (newValue != null) {
                  // TODO: Navega a screen correspondiente
                  debugPrint('$newValue seleccionado');
                }
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