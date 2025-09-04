import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/encuestas_result.dart';
import '../providers/encuestas_result_detail_provider_state.dart';

class ResultadosEncuestaScreen extends ConsumerStatefulWidget {
  static const routeName = 'resultados-encuesta';
  final String encuestaId;
  const ResultadosEncuestaScreen({super.key, required this.encuestaId});

  @override
  ResultadosEncuestaScreenState createState() =>
      ResultadosEncuestaScreenState();
}

class ResultadosEncuestaScreenState
    extends ConsumerState<ResultadosEncuestaScreen> {
  @override
  void initState() {
    super.initState();
    ref
        .read(encuestasResultDetailProvider.notifier)
        .loadResultEncuesta(int.parse(widget.encuestaId));
  }

  @override
  Widget build(BuildContext context) {
    final EncuestasResultDetail? resultadosEncuesta = ref.watch(
      encuestasResultDetailProvider,
    )[widget.encuestaId];

    final isLoading = ref
        .read(encuestasResultDetailProvider.notifier)
        .isLoading;

    if (resultadosEncuesta == null && isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(strokeWidth: 3)),
      );
    }

    if (resultadosEncuesta == null) {
      return const Scaffold(
        body: Center(child: Text('Encuesta no encontrada')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(resultadosEncuesta.titulo),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref
                  .read(encuestasResultDetailProvider.notifier)
                  .loadResultEncuesta(int.parse(widget.encuestaId));
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: resultadosEncuesta.resultados.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final pregunta = resultadosEncuesta.resultados[index];
          final totalRespuestas = pregunta.opciones.fold<int>(
            0,
            (sum, opt) => sum + opt.countRespuestasOption,
          );

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pregunta
                    Text(
                      pregunta.texto,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                          
                    // Opciones
                    ...pregunta.opciones.map((opcion) {
                      final porcentaje = totalRespuestas == 0
                          ? 0.0
                          : opcion.countRespuestasOption / totalRespuestas;
                          
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(opcion.texto),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LinearProgressIndicator(
                                  value: porcentaje,
                                  backgroundColor: Colors.grey.shade200,
                                  color: Colors.blueAccent,
                                  minHeight: 8,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${opcion.countRespuestasOption} respuestas (${(porcentaje * 100).toStringAsFixed(1)}%)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.people_alt_outlined),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                      'Usuarios que eligieron "${opcion.texto}"',
                                    ),
                                    content: SizedBox(
                                      width: double.maxFinite,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: opcion.usuarios.length,
                                        itemBuilder: (context, userIndex) {
                                          final usuario =
                                              opcion.usuarios[userIndex];
                                          return ListTile(
                                            leading: const CircleAvatar(
                                              child: Icon(Icons.person),
                                            ),
                                            title: Text(usuario.usuario),
                                          );
                                        },
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cerrar'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      );
                    }),
                          
                    if (pregunta.countRespuestasAbiertas > 0) ...[
                      // Respuestas abiertas
                      const Divider(),
                      const SizedBox(height: 8),
                      Column(
                        children: pregunta.respuestasAbiertas.map((respuesta) {
                          return ListTile(
                            leading: const Icon(
                              Icons.comment,
                              color: Colors.blueAccent,
                            ),
                            title: Text(
                              respuesta.usuario,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(respuesta.respuestaTexto),
                          );
                        }).toList(),
                      ),
                    ] else if (pregunta.opciones.fold<int>(
                          0,
                          (sum, opt) => sum + opt.countRespuestasOption,
                        ) ==
                        0) ...[
                      // Respuestas abiertas
                      const Divider(),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'Aún nadie ha respondido.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),

      // 🔴 Botón Eliminar al final
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          onPressed: () {
            // Aquí pones la lógica para eliminar encuesta
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("Confirmar eliminación"),
                content: const Text(
                  "¿Estás seguro de que deseas eliminar esta encuesta?",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancelar"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      // Aquí eliminas en backend
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Encuesta eliminada correctamente"),
                        ),
                      );
                    },
                    child: const Text("Eliminar"),
                  ),
                ],
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.delete_outline),
          label: const Text("Eliminar Encuesta"),
        ),
      ),
    );
  }
}
