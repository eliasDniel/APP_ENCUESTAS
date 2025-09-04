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
  List<PreguntaForm> preguntas = [PreguntaForm()];

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    for (var pregunta in preguntas) {
      pregunta.dispose();
    }
    super.dispose();
  }

  void _addPregunta() {
    setState(() {
      preguntas.add(PreguntaForm());
    });
  }

  void _removePregunta(int index) {
    setState(() {
      preguntas[index].dispose();
      preguntas.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Encuesta'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información básica de la encuesta
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.deepPurple),
                        const SizedBox(width: 8),
                        Text(
                          'Información básica',
                          style: textStyle.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _tituloController,
                      decoration: InputDecoration(
                        labelText: 'Título de la encuesta',
                        prefixIcon: const Icon(Icons.title),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _descripcionController,
                      maxLines: 3,
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
            
            // Sección de preguntas
            Row(
              children: [
                const Icon(Icons.quiz, color: Colors.deepPurple),
                const SizedBox(width: 8),
                Text(
                  'Preguntas',
                  style: textStyle.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Lista de preguntas
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: preguntas.length,
              itemBuilder: (context, index) {
                final pregunta = preguntas[index];
                return Card(
                  key: pregunta.key,
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Texto de la pregunta y botón eliminar
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: pregunta.textoController,
                                decoration: InputDecoration(
                                  labelText: 'Pregunta ${index + 1}',
                                  prefixIcon: const Icon(Icons.help_outline),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Tooltip(
                              message: 'Eliminar pregunta',
                              child: IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red),
                                onPressed: preguntas.length > 1 ? () => _removePregunta(index) : null,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Selector de tipo de pregunta
                        DropdownButtonFormField<String>(
                          value: pregunta.tipo,
                          decoration: InputDecoration(
                            labelText: 'Tipo de pregunta',
                            prefixIcon: const Icon(Icons.category, color: Colors.deepPurple, size: 20),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'opcion_multiple',
                              child: Text('Opción múltiple'),
                            ),
                            DropdownMenuItem(
                              value: 'opcion_libre',
                              child: Text('Opción libre'),
                            ),
                          ],
                          onChanged: (val) {
                            setState(() {
                              pregunta.tipo = val!;
                            });
                          },
                        ),
                        
                        // Opciones para preguntas de opción múltiple
                        if (pregunta.tipo == 'opcion_multiple') ...[
                          const SizedBox(height: 16),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: pregunta.opcionesControllers.length,
                            itemBuilder: (context, opcionIndex) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: pregunta.opcionesControllers[opcionIndex],
                                        decoration: InputDecoration(
                                          labelText: 'Opción ${opcionIndex + 1}',
                                          prefixIcon: const Icon(Icons.radio_button_unchecked, size: 18),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Tooltip(
                                      message: 'Eliminar opción',
                                      child: IconButton(
                                        icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                                        onPressed: pregunta.opcionesControllers.length > 2
                                            ? () {
                                                setState(() {
                                                  pregunta.removeOpcion(opcionIndex);
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
                        ],
                        
                        // Campo de ejemplo para preguntas de texto libre
                        if (pregunta.tipo == 'opcion_libre') ...[
                          const SizedBox(height: 16),
                          TextField(
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: 'Respuesta de ejemplo',
                              hintText: 'Los usuarios podrán escribir aquí su respuesta...',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              prefixIcon: const Icon(Icons.edit_note),
                              fillColor: Colors.grey[100],
                              filled: true,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 20),
            
            // Botón agregar pregunta
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Agregar pregunta'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: _addPregunta,
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Botón crear encuesta
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
                    const SnackBar(
                      content: Text('¡Encuesta creada exitosamente!'),
                      backgroundColor: Colors.green,
                    ),
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
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// Clase helper para manejar el estado de cada pregunta
class PreguntaForm {
  final Key key = UniqueKey();
  final TextEditingController textoController = TextEditingController();
  String tipo = 'opcion_multiple';
  List<TextEditingController> opcionesControllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  void addOpcion() {
    opcionesControllers.add(TextEditingController());
  }

  void removeOpcion(int index) {
    if (opcionesControllers.length > 2 && index < opcionesControllers.length) {
      opcionesControllers[index].dispose();
      opcionesControllers.removeAt(index);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'texto': textoController.text,
      'tipo': tipo,
      if (tipo == 'opcion_multiple')
        'opciones': opcionesControllers.map((controller) => controller.text).toList(),
    };
  }

  void dispose() {
    textoController.dispose();
    for (var controller in opcionesControllers) {
      controller.dispose();
    }
  }
}