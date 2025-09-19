import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class LoginCognitoServicio {
  // Verificar si hay sesión activa (para no hacer login siempre que se inicie la app)
  Future<bool> isLoggedIn() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      return session.isSignedIn;
    } catch (e) {
      print('Error checking session: $e');
      return false;
    }
  }

  // Login
  Future<AuthSession?> signIn(String username, String password) async {
    print('Intentando signIn con username: $username');
    try {
      final result = await Amplify.Auth.signIn(
        username: username,
        password: password,
      );
      if (result.isSignedIn) {
        final session = await Amplify.Auth.fetchAuthSession();
        print('Login exitoso');
        return session;
      } else {
        throw Exception('Login fallido sin razón clara');
      }
    } on AuthException catch (e) {
      print('Error en login: ${e.message}');
      throw Exception(e.message);
    } catch (e) {
      print('Error desconocido en signIn: $e');
      throw Exception('Error desconocido: $e');
    }
  }

  // Logout
  Future<void> signOut() async {
    try {
      await Amplify.Auth.signOut();
      print('Logout exitoso');
    } catch (e) {
      print('Error en logout: $e');
    }
  }

  // Registro
  Future<SignUpResult?> signUp(String username, String password, {Map<CognitoUserAttributeKey, String>? attributes}) async {
    try {
      final result = await Amplify.Auth.signUp(
        username: username,
        password: password,
        options: SignUpOptions(userAttributes: attributes ?? {}),
      );
      return result;
    } on AuthException catch (e) {
      throw Exception('Error en registro: ${e.message}');
    }
  }
}