

import 'package:app_encuentas_prueba_tecnica/features/encuestas/presentation/providers/encuesta_provider_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class CreateEncuestaScreen extends ConsumerStatefulWidget {
  static const String routeName = 'create-encuesta';
  const CreateEncuestaScreen({super.key});

  @override
  CreateEncuestaScreenState createState() => CreateEncuestaScreenState();
}

class CreateEncuestaScreenState extends ConsumerState<CreateEncuestaScreen> {
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  List<PreguntaForm> preguntas = [PreguntaForm(key: UniqueKey())];

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    setState(() {
      preguntas[index].dispose();
      preguntas.removeAt(index);
    });
  }


  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Encuesta')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descripcionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            const SizedBox(height: 24),
            const Text('Preguntas', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            // Eliminado ListView.builder y Card duplicados, dejando solo la UI principal
                                            prefixIcon: const Icon(Icons.title),
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        TextField(
                                          controller: _descripcionController,
                                          maxLines: 2,
                                          decoration: InputDecoration(
                                            labelText: 'Descripción',
                                            prefixIcon: const Icon(Icons.description),
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 28),
                                Row(
                                  children: [
                                    const Icon(Icons.list_alt, color: Colors.deepPurple),
                                    const SizedBox(width: 8),
                                    Text('Preguntas', style: textStyle.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: preguntas.length,
                                  itemBuilder: (context, idx) {
                                    final pregunta = preguntas[idx];
                                    return Card(
                                      key: pregunta.key,
                                      elevation: 2,
                                      margin: const EdgeInsets.symmetric(vertical: 10),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: TextField(
                                                    controller: pregunta.textoController,
                                                    decoration: InputDecoration(
                                                      labelText: 'Texto de la pregunta',
                                                      prefixIcon: const Icon(Icons.question_mark_outlined),
                                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Tooltip(
                                                  message: 'Eliminar pregunta',
                                                  child: IconButton(
                                                    icon: const Icon(Icons.delete, color: Colors.red),
                                                    onPressed: preguntas.length > 1 ? () => _removePregunta(idx) : null,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 12),
                                            Row(
                                              children: [
                                                const Icon(Icons.category, color: Colors.deepPurple, size: 20),
                                                const SizedBox(width: 6),
                                                Expanded(
                                                  child: DropdownButtonFormField<String>(
                                                    value: pregunta.tipo,
                                                    decoration: InputDecoration(
                                                      labelText: 'Tipo de pregunta',
                                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                                    ),
                                                    items: [
                                                      DropdownMenuItem(value: 'opcion_multiple', child: Text('Opción múltiple', style: textStyle.bodyLarge)),
                                                      DropdownMenuItem(value: 'opcion_libre', child: Text('Opción libre', style: textStyle.bodyLarge)),
                                                    ],
                                                    onChanged: (val) {
                                                      setState(() {
                                                        pregunta.tipo = val!;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (pregunta.tipo == 'opcion_multiple') ...[
                                              const SizedBox(height: 14),
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemCount: pregunta.opcionesControllers.length,
                                                itemBuilder: (context, opIdx) {
                                                  return Padding(
                                                    padding: const EdgeInsets.only(bottom: 8.0),
                                                    child: Row(
                                                      key: pregunta.opcionesKeys[opIdx],
                                                      children: [
                                                        Expanded(
                                                          child: TextField(
                                                            controller: pregunta.opcionesControllers[opIdx],
                                                            decoration: InputDecoration(
                                                              labelText: 'Opción ${opIdx + 1}',
                                                              prefixIcon: const Icon(Icons.circle_outlined, size: 18),
                                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 6),
                                                        Tooltip(
                                                          message: 'Eliminar opción',
                                                          child: IconButton(
                                                            icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
                                                            onPressed: pregunta.opcionesControllers.length > 1
                                                                ? () {
                                                                    setState(() {
                                                                      pregunta.removeOpcion(opIdx);
                                                                    });
                                                                  }
                                                                : null,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: TextButton.icon(
                                                  icon: const Icon(Icons.add_circle_outline, color: Colors.deepPurple),
                                                  label: const Text('Agregar opción'),
                                                  style: TextButton.styleFrom(foregroundColor: Colors.deepPurple),
                                                  onPressed: () {
                                                    setState(() {
                                                      pregunta.addOpcion();
                                                    });
                                                  },
                                                ),
                                              ),
                                            ]
                                            else if (pregunta.tipo == 'opcion_libre') ...[
                                              const SizedBox(height: 14),
                                              TextField(
                                                enabled: false,
                                                decoration: InputDecoration(
                                                  labelText: 'Respuesta de ejemplo',
                                                  hintText: 'Ingrese aquí una respuesta libre',
                                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                                  prefixIcon: const Icon(Icons.edit_note),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 16),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.add),
                                    label: const Text('Agregar pregunta'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurple,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                                    ),
                                    onPressed: _addPregunta,
                                  ),
                                ),
                                const SizedBox(height: 32),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      final body = {
                                        "titulo": _tituloController.text,
                                        "descripcion": _descripcionController.text,
                                        "preguntas": preguntas.map((p) => p.toMap()).toList(),
                                      };
                                      ref.read(encuestasProvider.notifier).createEncuestaMethod(body);
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Encuesta generada. Revisa la consola.')),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurple,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      textStyle: textStyle.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                      elevation: 3,
                                    ),
                                    child: const Text('Crear Encuesta'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
}
