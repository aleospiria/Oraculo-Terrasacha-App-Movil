import 'dart:async';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';  // Para fetch token
import 'package:oraculo_terrasacha/Screens/HomeScreen.dart';  // Para back

class SeleccionRapidaImagenesScreen extends StatefulWidget {
  const SeleccionRapidaImagenesScreen({super.key});

  @override
  _SeleccionRapidaImagenesScreenState createState() => _SeleccionRapidaImagenesScreenState();
}

class _SeleccionRapidaImagenesScreenState extends State<SeleccionRapidaImagenesScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final List<LatLng> _polygonPoints = [];
  Polygon? _currentPolygon;
  String _statusMessage = '';
  bool _isLoading = false;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(4.60971, -74.08175),  // Ej. Bogotá, ajusta a tu área default
    zoom: 10,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selección Rápida de Imágenes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _polygonPoints.length >= 3 ? _analyzePolygon : null,  // Habilitar si polígono válido
            tooltip: 'Analizar Polígono',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _clearPolygon,
            tooltip: 'Limpiar Polígono',
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.satellite,  // Vista satelital por default
            initialCameraPosition: _initialPosition,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            polygons: _currentPolygon != null ? {_currentPolygon!} : {},
            onTap: _addPointToPolygon,
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.white.withOpacity(0.8),
              child: Text(_statusMessage, style: const TextStyle(color: Colors.black)),
            ),
          ),
        ],
      ),
    );
  }

  void _addPointToPolygon(LatLng point) {
    setState(() {
      _polygonPoints.add(point);
      _updatePolygon();
    });
  }

  void _updatePolygon() {
    if (_polygonPoints.length >= 3) {
      _currentPolygon = Polygon(
        polygonId: const PolygonId('selected_polygon'),
        points: _polygonPoints,
        strokeColor: Colors.blue,
        strokeWidth: 2,
        fillColor: Colors.blue.withOpacity(0.3),
      );
    }
  }

  void _clearPolygon() {
    setState(() {
      _polygonPoints.clear();
      _currentPolygon = null;
      _statusMessage = '';
    });
  }

  Future<void> _analyzePolygon() async {
    if (_polygonPoints.isEmpty) return;

    setState(() {
      _isLoading = true;
      _statusMessage = 'Analizando polígono...';
    });

    try {
      // Fetch token de Cognito para auth
      final session = await Amplify.Auth.fetchAuthSession() as CognitoAuthSession;
      final token = session.userPoolTokens?.idToken.jwtToken ?? '';

      // Prepara body para API search (ajusta según docs: coords como lista de [lat, lng])
      final coords = _polygonPoints.map((p) => [p.latitude, p.longitude]).toList();
      final body = jsonEncode({
        'geometry': {'type': 'Polygon', 'coordinates': [coords]},  // Formato GeoJSON para API
        // Agrega otros params si necesita, ej. dates, satellite_type
      });

      // Llama a API /api/v1/satellites-imagenes/search
      final response = await http.post(
        Uri.parse('https://oraculo.terrasacha.com/api/v1/satellites-imagenes/search'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _statusMessage = 'Imágenes encontradas: ${data.length}. Previsualizando...';
        });
        // Aquí llama a /api/v1/previsualizar-imagen con ID de imagen encontrada
        // Luego /api/v1/export-images y /api/v1/analisis/start
        // Ej. Muestra preview en un dialog o lista
      } else {
        setState(() {
          _statusMessage = 'Error en búsqueda: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

extension on CognitoAuthSession {
  get userPoolTokens => null;
}