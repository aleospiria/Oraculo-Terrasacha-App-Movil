import 'package:flutter/material.dart';
import 'package:oraculo_terrasacha/Servicios/LoginCognitoServicio.dart';
import 'package:oraculo_terrasacha/Screens/HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores para capturar los valores de los inputs
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();

  // Variable para manejar estado de loading
  bool _isLoading = false;

  //Función para liberar los controladores cuando el widget se destruye
  @override
  void dispose() {
    _usuarioController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.8,
          child: Container(
            padding: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10.0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'ORACULO',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Inicio de sesión',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 32.0),
                // Entrada de Usuario con controlador
                TextField(
                  controller: _usuarioController,
                  decoration: InputDecoration(
                    hintText: 'Usuario',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                // Entrada de Contraseña con controlador
                TextField(
                  controller: _contrasenaController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Contraseña',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      // TODO: Falta crear Screen a Olvido su contraseña
                      debugPrint('Olvidó contraseña tocado');
                    },
                    child: Text(
                      '¿Olvidó su contraseña?',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.blue[800],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                // Botón de Ingresar
                _isLoading
                    ? const Center(child: CircularProgressIndicator()) // Muestra loading si está procesando
                    : ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _isLoading = true; // Inicia loading
                    });

                    // Captura los valores
                    String usuario = _usuarioController.text.trim();
                    String contrasena = _contrasenaController.text.trim();

                    // Validación
                    if (usuario.isEmpty || contrasena.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Por favor, completa todos los campos')),
                      );
                      setState(() {
                        _isLoading = false;
                      });
                      return;
                    }

                    try {
                      final authService = LoginCognitoServicio();
                      final session = await authService.signIn(usuario, contrasena);

                      if (session != null && session.isSignedIn) {
                        // Login exitoso: Navega a la siguiente pantalla
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$e')),
                      );
                      debugPrint('Error en login: $e');
                    } finally {
                      setState(() {
                        _isLoading = false; // Termina loading
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('Ingresar'),
                ),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () {
                    // TODO: Falta crear Screen a Registrarme
                    debugPrint('Registrarme tocado');
                  },
                  child: const Text(
                    'Registrarme',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}