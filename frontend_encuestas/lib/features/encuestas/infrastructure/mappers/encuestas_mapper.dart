import 'package:app_encuentas_prueba_tecnica/features/encuestas/infrastructure/models/encuestas_response.dart';

import '../../domain/domain.dart';

class EncuestasMapper {
  static Encuesta fromJsonToEntity(EncuestaResult json) => Encuesta(
    id: json.id,
    titulo: json.titulo,
    descripcion: json.descripcion,
    fechaCreacion: json.fechaCreacion,
    cantidadPreguntas: json.cantidadPreguntas,
    creadaPor: json.creadaPor,
    estado: json.estado,
  );
}
