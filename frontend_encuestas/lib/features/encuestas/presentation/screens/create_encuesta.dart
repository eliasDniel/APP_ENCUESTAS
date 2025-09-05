import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_encuentas_prueba_tecnica/features/encuestas/presentation/providers/encuesta_provider_state.dart';

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

    bool get _isFormValid {
    if (_tituloController.text.trim().isEmpty) return false;
    if (_descripcionController.text.trim().isEmpty) return false;
    if (preguntas.isEmpty) return false;
    for (final pregunta in preguntas) {
      if (pregunta.textoController.text.trim().isEmpty) return false;
      if (pregunta.tipo == 'opcion_multiple') {
        if (pregunta.opcionesControllers.isEmpty) return false;
        for (final op in pregunta.opcionesControllers) {
          if (op.text.trim().isEmpty) return false;
        }
      }
    }
    return true;
  }

  void _onFormChanged() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _tituloController.addListener(_onFormChanged);
    _descripcionController.addListener(_onFormChanged);
  }

   @override
  void dispose() {
    _tituloController.removeListener(_onFormChanged);
    _descripcionController.removeListener(_onFormChanged);
    _tituloController.dispose();
    _descripcionController.dispose();
    for (var p in preguntas) {
      p.dispose();
    }
    super.dispose();
  }
  void _addPregunta() {
    setState(() {
      final pregunta = PreguntaForm(key: UniqueKey());
      pregunta.textoController.addListener(_onFormChanged);
      pregunta.addOpcionListener(_onFormChanged);
      preguntas.add(pregunta);
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
        centerTitle: true,
        title: Text(
          'Crear Encuesta',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/images/create.png',
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _tituloController,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Título',
                    labelStyle: TextStyle(color: Colors.grey[700]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descripcionController,
                  maxLines: 2,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    labelStyle: TextStyle(color: Colors.grey[700]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text(
              'Preguntas',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF2D3A4A),
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: preguntas.length,
              itemBuilder: (context, idx) {
                final pregunta = preguntas[idx];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: pregunta.textoController,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                              labelText: 'Texto de la pregunta',
                              labelStyle: TextStyle(color: Colors.grey[700]),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Tooltip(
                          message: 'Eliminar pregunta',
                          child: IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Color(0xFFD32F2F),
                            ),
                            onPressed: preguntas.length > 1
                                ? () => _removePregunta(idx)
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: pregunta.tipo,
                      decoration: InputDecoration(
                        labelText: 'Tipo de pregunta',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'opcion_multiple',
                          child: Text(
                            'Opción múltiple',
                            style: textStyle.bodyLarge,
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'opcion_libre',
                          child: Text(
                            'Opción libre',
                            style: textStyle.bodyLarge,
                          ),
                        ),
                      ],
                      onChanged: (val) {
                        setState(() {
                          pregunta.tipo = val!;
                        });
                      },
                    ),
                    if (pregunta.tipo == 'opcion_multiple') ...[
                      const SizedBox(height: 12),
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
                                    controller:
                                        pregunta.opcionesControllers[opIdx],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: 'Opción ${opIdx + 1}',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Tooltip(
                                  message: 'Eliminar opción',
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                      color: Color(0xFFD32F2F),
                                    ),
                                    onPressed:
                                        pregunta.opcionesControllers.length > 1
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
                          icon: const Icon(
                            Icons.add_circle_outline,
                            color: Color(0xFF1976D2),
                          ),
                          label: const Text(
                            'Agregar opción',
                            style: TextStyle(
                              color: Color(0xFF1976D2),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF1976D2),
                          ),
                          onPressed: () {
                            setState(() {
                              pregunta.addOpcion();
                            });
                          },
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.add, color: Color(0xFF388E3C)),
                  label: const Text(
                    'Pregunta',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Color(0xFF388E3C),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color(0xFF388E3C),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    foregroundColor: const Color(0xFF388E3C),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                  ),
                  onPressed: _addPregunta,
                ),
              ),
              SizedBox(width: 3),
              Expanded(
                flex: 3,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  onPressed: _isFormValid
                      ? () {
                          final body = {
                            "titulo": _tituloController.text,
                            "descripcion": _descripcionController.text,
                            "preguntas": preguntas.map((p) => p.toMap()).toList(),
                          };
                          ref
                              .read(encuestasProvider.notifier)
                              .createEncuestaMethod(body);
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Encuesta generada. Revisa la consola.'),
                            ),
                          );
                        }
                      : null,
                  child: const Text(
                    'Crear Encuesta',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PreguntaForm {
  final Key key;
  final textoController = TextEditingController();
  String tipo = 'opcion_multiple';
  List<TextEditingController> opcionesControllers = [TextEditingController()];
  List<Key> opcionesKeys = [UniqueKey()];
  final List<VoidCallback> _opcionListeners = [];

  PreguntaForm({Key? key}) : key = key ?? UniqueKey() {
    textoController.addListener(() {});
  }

  void addOpcion() {
    final controller = TextEditingController();
    opcionesControllers.add(controller);
    opcionesKeys.add(UniqueKey());
    for (final listener in _opcionListeners) {
      controller.addListener(listener);
    }
  }

  void addOpcionListener(VoidCallback listener) {
    _opcionListeners.add(listener);
    for (final c in opcionesControllers) {
      c.addListener(listener);
    }
  }

  void removeOpcion(int idx) {
    opcionesControllers[idx].dispose();
    opcionesControllers.removeAt(idx);
    opcionesKeys.removeAt(idx);
  }

  Map<String, dynamic> toMap() {
    return {
      "texto": textoController.text,
      "tipo": tipo,
      "opciones": tipo == 'opcion_multiple'
          ? opcionesControllers.map((c) => {"texto": c.text}).toList()
          : [],
    };
  }

  void dispose() {
    textoController.dispose();
    for (var c in opcionesControllers) {
      c.dispose();
    }
  }
}
