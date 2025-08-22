import 'package:http/http.dart' as http; // Importa el paquete http
import 'package:oraculo_terrasacha/Modelos/ConsultaProyectoResponse.dart'; // Importa tu modelo de respuesta

// Definimos un enum para los satélites para mayor seguridad de tipo
enum Satellite {
  lc08,
  lc09,
  s2,
}

// Extensión para obtener el valor de string del enum
extension SatelliteExtension on Satellite {
  String get value {
    switch (this) {
      case Satellite.lc08:
        return 'LC08';
      case Satellite.lc09:
        return 'LC09';
      case Satellite.s2:
        return 'S2';
    }
  }
}

// Creamos una clase para el servicio de API
class ApiService {
  static Future<ConsultaProyectoResponse> realizarConsultaProyecto({
    required String projectID,
    String? cedulaCatastral,
    Satellite? imgAnteriorSatellite,
    int? imgAnteriorYearSelected,
    int? imgAnteriorMonthInitial,
    int? imgAnteriorMonthFinal,
    int? imgAnteriorNubosidadMaxima,
    Satellite? imgPosteriorSatellite,
    int? imgPosteriorYearSelected,
    int? imgPosteriorMonthInitial,
    int? imgPosteriorMonthFinal,
    int? imgPosteriorNubosidadMaxima,
  }) async {
    final Map<String, String> queryParams = {
      'projectID': projectID,
    };

    if (cedulaCatastral != null) {
      queryParams['cedula_catastral'] = cedulaCatastral;
    }
    if (imgAnteriorSatellite != null) {
      queryParams['img_anterior.satellite'] = imgAnteriorSatellite.value;
    }
    if (imgAnteriorYearSelected != null) {
      queryParams['img_anterior.year_selected'] = imgAnteriorYearSelected.toString();
    }
    if (imgAnteriorMonthInitial != null) {
      queryParams['img_anterior.month_initial'] = imgAnteriorMonthInitial.toString().padLeft(2, '0');
    }
    if (imgAnteriorMonthFinal != null) {
      queryParams['img_anterior.month_final'] = imgAnteriorMonthFinal.toString().padLeft(2, '0');
    }
    if (imgAnteriorNubosidadMaxima != null) {
      queryParams['img_anterior.nubosidad_maxima'] = imgAnteriorNubosidadMaxima.toString();
    }
    if (imgPosteriorSatellite != null) {
      queryParams['img_posterior.satellite'] = imgPosteriorSatellite.value;
    }
    if (imgPosteriorYearSelected != null) {
      queryParams['img_posterior.year_selected'] = imgPosteriorYearSelected.toString();
    }
    if (imgPosteriorMonthInitial != null) {
      queryParams['img_posterior.month_initial'] = imgPosteriorMonthInitial.toString().padLeft(2, '0');
    }
    if (imgPosteriorMonthFinal != null) {
      queryParams['img_posterior.month_final'] = imgPosteriorMonthFinal.toString().padLeft(2, '0');
    }
    if (imgPosteriorNubosidadMaxima != null) {
      queryParams['img_posterior.nubosidad_maxima'] = imgPosteriorNubosidadMaxima.toString();
    }

    //Donde se pide la peticion (Endpoint) 
    final uri = Uri.https('oraculo.terrasacha.com', '/api/v1/consulta-proyecto', queryParams);

    try {
      final response = await http.post(uri);

      if (response.statusCode == 200) {
        return ConsultaProyectoResponseFromJson(response.body);
      } else {
        throw Exception('Error al cargar la consulta: ${response.statusCode}. Cuerpo: ${response.body}');
      }
    } catch (e) {
      throw Exception('Fallo al realizar la consulta: $e');
    }
  }
}