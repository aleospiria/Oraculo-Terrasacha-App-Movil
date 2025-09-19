// lib/main.dart
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:oraculo_terrasacha/Screens/LoginScreen.dart';
import 'package:oraculo_terrasacha/Servicios/LoginCognitoServicio.dart';
import 'package:oraculo_terrasacha/Screens/HomeScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: "assets/.env");
    print('dotenv cargado exitosamente');
  } catch (e) {
    print('Error cargando .env: $e');
    runApp(const ErrorApp(message: 'Error: .env no encontrado en assets/'));
    return;
  }

  final region = dotenv.env['USERPOOLS_US_REGION'] ?? 'us-east-1';
  final userPoolId = dotenv.env['USERPOOLS_US_USERPOOL_ID'] ?? '';
  final appClientId = dotenv.env['USERPOOLS_US_APP_CLIENT_ID'] ?? '';
  final appClientSecret = dotenv.env['USERPOOLS_US_APP_CLIENT_SECRET'] ?? '';
  final redirectUri = dotenv.env['USERPOOLS_US_REDIRECT_URI'] ?? 'http://localhost:5001/callback';
  final logoutUri = dotenv.env['USERPOOLS_US_LOGOUT_URI'] ?? 'http://localhost:5001/';

  if (userPoolId.isEmpty || appClientId.isEmpty) {
    throw Exception('Credenciales de Cognito no configuradas en .env');
  }

  final amplifyConfig = '''
  {
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "auth": {
      "plugins": {
        "awsCognitoAuthPlugin": {
          "UserAgent": "aws-amplify/flutter/0.1.0",
          "Version": "0.1.0",
          "IdentityManager": {
            "Default": {}
          },
          "CognitoUserPool": {
            "Default": {
              "PoolId": "$userPoolId",
              "AppClientId": "$appClientId",
              "AppClientSecret": "$appClientSecret",
              "Region": "$region"
            }
          },
          "Auth": {
            "Default": {
              "authenticationFlowType": "USER_SRP_AUTH",
              "socialProviders": [],
              "usernameAttributes": ["USERNAME"],
              "signupAttributes": [],
              "passwordProtectionSettings": {
                "passwordPolicyMinLength": 8,
                "passwordPolicyCharacters": ["REQUIRES_LOWERCASE", "REQUIRES_UPPERCASE", "REQUIRES_NUMBERS", "REQUIRES_SYMBOLS"]
              },
              "mfaConfiguration": "OFF",
              "mfaTypes": ["SMS"],
              "verificationMechanisms": ["EMAIL"]
            }
          },
          "OAuth": {
            "Default": {
              "WebDomain": "",
              "AppClientId": "$appClientId",
              "AppClientSecret": "$appClientSecret",
              "SignInRedirectURI": "$redirectUri",
              "SignOutRedirectURI": "$logoutUri",
              "Scopes": ["openid", "email", "profile"]
            }
          }
        }
      }
    }
  }
  ''';

  try {
    await Amplify.addPlugins([AmplifyAuthCognito()]);
    await Amplify.configure(amplifyConfig);
    print('Amplify configurado exitosamente');
  } on AmplifyAlreadyConfiguredException {
    print('Amplify ya está configurado (ignorando reconfiguración)');
  } on Exception catch (e) {
    print('Error configurando Amplify: $e');
    runApp(ErrorApp(message: 'Error configurando Amplify: $e'));
    return;
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget _initialScreen = const Scaffold(body: Center(child: CircularProgressIndicator()));  // Loading inicial

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final authService = LoginCognitoServicio();
    final isLoggedIn = await authService.isLoggedIn();
    setState(() {
      _initialScreen = isLoggedIn ? const HomeScreen() : const LoginScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Oraculo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _initialScreen,
    );
  }
}

// Widget para mostrar error
class ErrorApp extends StatelessWidget {
  final String message;
  const ErrorApp({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: Text(message)),
      ),
    );
  }
}