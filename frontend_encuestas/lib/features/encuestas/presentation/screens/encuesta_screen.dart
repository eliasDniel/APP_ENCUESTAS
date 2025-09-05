

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/domain.dart';
import '../providers/providers.dart';

class DetalleEncuestaScreen extends ConsumerStatefulWidget {
  static const String routeName = 'encuesta-screen';
  final String encuestaId;
  const DetalleEncuestaScreen({super.key, required this.encuestaId});

  @override
  EncuestaScreenState createState() => EncuestaScreenState();
}

class EncuestaScreenState extends ConsumerState<DetalleEncuestaScreen> {
  SurveyQuestion? survey;
  List<TextEditingController>? controllers;
  List<int?>? seleccionUnica;
  bool allAnswered = false;
  @override
  void initState() {
    super.initState();
    ref
        .read(encuestaInfoProvider.notifier)
        .loadEncuestaInfo(int.parse(widget.encuestaId));
  }

  void _checkAllAnswered(DetalleEncuesta encuesta) {
    final preguntasIds = encuesta.preguntas.map((p) => p.id).toSet();
    final respondidas = survey!.respuestas.map((q) => q.preguntaId).toSet();

    final isAllAnswered =
        preguntasIds.isNotEmpty &&
        preguntasIds.length == respondidas.length &&
        survey!.respuestas.every(
          (q) =>
              (q.respuesta != null && q.respuesta!.isNotEmpty) ||
              q.option != null,
        );

    setState(() {
      allAnswered = isAllAnswered;
    });
  }

  @override
  Widget build(BuildContext context) {
    final DetalleEncuesta? encuesta = ref.watch(
      encuestaInfoProvider,
    )[widget.encuestaId];
    if (encuesta != null &&
        (controllers == null ||
            controllers!.length != encuesta.preguntas.length)) {
      controllers = List.generate(
        encuesta.preguntas.length,
        (_) => TextEditingController(),
      );
      seleccionUnica = List<int?>.filled(encuesta.preguntas.length, null);
      survey = SurveyQuestion(encuestaId: encuesta.id, respuestas: []);
    }
    if (encuesta == null && ref.read(encuestaInfoProvider.notifier).isLoading) {
      return Scaffold(
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(strokeWidth: 2.0),
              SizedBox(height: 10),
              Text('Cargando encuesta...'),
            ],
          ),
        ),
      );
    }
    if (encuesta == null) {
      return Scaffold(
        body: const Center(child: Text('Encuesta no encontrada')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          encuesta.titulo,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        elevation: 0,
      ),
      body: encuesta.estado == 'Pendiente'
          ? Container(
              color: const Color(0xFFF5F6FA),
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        encuesta.titulo,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        encuesta.descripcion,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ...List.generate(
                    
                    encuesta.preguntas.length, (index) {
                    final pregunta = encuesta.preguntas[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.deepPurple,
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  pregunta.texto,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (pregunta.tipo == 'opcion_libre')
                            TextField(
                              controller: controllers![index],
                              decoration: InputDecoration(
                                hintText: 'Respuesta...',
                                filled: true,
                                fillColor: Colors.grey[200],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onChanged: (val) {
                                final updated = List<Question>.from(
                                  survey!.respuestas,
                                );
                                final idx = updated.indexWhere(
                                  (q) => q.preguntaId == pregunta.id,
                                );
                                if (idx >= 0) {
                                  updated[idx] = updated[idx].copyWith(
                                    respuesta: val,
                                    option: null,
                                  );
                                } else {
                                  updated.add(
                                    Question(
                                      preguntaId: pregunta.id,
                                      respuesta: val,
                                    ),
                                  );
                                }
                                setState(() {
                                  survey = survey!.copyWith(
                                    respuestas: updated,
                                  );
                                });
                                _checkAllAnswered(
                                  encuesta,
                                ); // 🔥 valida después de cada respuesta
                              },
                            )
                          else if (pregunta.tipo == 'opcion_multiple')
                            Column(
                              children: List.generate(
                                pregunta.opciones.length,
                                (opIndex) {
                                  final opcion = pregunta.opciones[opIndex];
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: RadioListTile<int>(
                                      value: opcion.id,
                                      groupValue: seleccionUnica![index],
                                      onChanged: (val) {
                                        final updated = List<Question>.from(
                                          survey!.respuestas,
                                        );
                                        final idx = updated.indexWhere(
                                          (q) => q.preguntaId == pregunta.id,
                                        );
                                        if (idx >= 0) {
                                          updated[idx] = updated[idx]
                                              .copyWith(
                                                option: val,
                                                respuesta: null,
                                              );
                                        } else {
                                          updated.add(
                                            Question(
                                              preguntaId: pregunta.id,
                                              option: val,
                                            ),
                                          );
                                        }
                                        setState(() {
                                          seleccionUnica![index] = val;
                                          survey = survey!.copyWith(
                                            respuestas: updated,
                                          );
                                        });
                                        _checkAllAnswered(
                                          encuesta,
                                        ); // 🔥 valida después de cada respuesta
                                      },
                                          
                                      activeColor: Colors.deepPurple,
                                      title: Text(opcion.texto),
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: allAnswered
                          ? () async {
                              final respuestasList = survey!.respuestas.map((
                                q,
                              ) {
                                if (q.respuesta != null) {
                                  return {
                                    'pregunta_id': q.preguntaId,
                                    'respuesta_texto': q.respuesta,
                                  };
                                } else if (q.option != null) {
                                  return {
                                    'pregunta_id': q.preguntaId,
                                    'opcion_id': q.option,
                                  };
                                }
                                return {};
                              }).toList();

                              final body = {
                                'encuesta_id': survey!.encuestaId,
                                'respuestas': respuestasList,
                              };
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Encuesta respondida con éxito',
                                    ),
                                  ),
                                );
                                Navigator.of(context).pop();
                              }
                              await ref
                                  .read(encuestasProvider.notifier)
                                  .responderEncuestaMethod(body);

                              // Aquí tu lógica de envío
                            }
                          : null, // 🔥 deshabilitado si no todas contestadas
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Enviar respuestas',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/hecho.png'),
                const SizedBox(height: 16),
                const Text(
                  'La encuesta ya fue Realizada',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 200),
              ],
            ),
    );
  }
}
