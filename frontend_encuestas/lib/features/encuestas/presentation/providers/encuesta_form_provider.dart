// Modelo para una pregunta de encuesta
import 'package:app_encuentas_prueba_tecnica/features/encuestas/presentation/providers/encuesta_info_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SurveyQuestion {
  final int encuestaId;
  final List<Question> respuestas;

  SurveyQuestion({
     this.encuestaId = 0,
     this.respuestas = const [],
  });

  SurveyQuestion copyWith({List<Question>? respuestas}) => SurveyQuestion(
    encuestaId: encuestaId,
    respuestas: respuestas ?? this.respuestas,
  );
}


class Question {
  final int preguntaId;
  final String? respuesta;
  final int? option; // enum: multipleChoice, openEnded

  Question({
     this.preguntaId = 0,
    this.respuesta,
    this.option,
  });

  Question copyWith({String? respuesta, int? option}) => Question(
    preguntaId: preguntaId,
    respuesta: respuesta ?? this.respuesta,
    option: option ?? this.option,
  );
}



