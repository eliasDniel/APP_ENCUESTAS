// ! 2: STATENOTIFIER
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/domain.dart';
import 'providers.dart';


// ! 1: STATENOTIFIERPROVIDE: AQUI ES DONDE VOY A USARLO EN EL FRONTEND
final encuestasProvider =
    StateNotifierProvider<EncuestasNotifier, List<Encuesta>>((ref) {
      final fetchEncuestas = ref
          .watch(encuestasRepositoryProvider)
          .getNowEncuestas;
      final responderEncuesta = ref
          .watch(encuestasRepositoryProvider)
          .responderEncuesta;
      final crearEncuesta = ref
          .watch(encuestasRepositoryProvider)
          .submitEncuesta;
      final encuestasRepository = ref.watch(encuestasRepositoryProvider);
      return EncuestasNotifier(
        fetchEncuestas: fetchEncuestas,
        responderEncuesta: responderEncuesta,
        crearEncuesta: crearEncuesta,
        encuestasRepository: encuestasRepository,
      );
    });

typedef EncuestasCallBck = Future<List<Encuesta>> Function({int page});
typedef ResponderEncuestaCallBack =
    Future<Encuesta> Function(Map<String, dynamic> data);
typedef CreateEncuestaCallBack =
    Future<Encuesta> Function(Map<String, dynamic> data);

class EncuestasNotifier extends StateNotifier<List<Encuesta>> {
  final EncuestasCallBck fetchEncuestas;
  final ResponderEncuestaCallBack responderEncuesta;
  final CreateEncuestaCallBack crearEncuesta;
  final EncuestasRepository encuestasRepository;

  EncuestasNotifier({
    required this.fetchEncuestas,
    required this.responderEncuesta,
    required this.crearEncuesta,
    required this.encuestasRepository,
  }) : super([]) {
    loadNextPage();
  }

  bool isLoading = false;
  int limit = 10;
  int page = 1;

  Future<void> loadNextPage() async {
    if (isLoading) return;
    isLoading = true;
    final newEncuestas = await fetchEncuestas(page: page);
    if (newEncuestas.isEmpty) {
      isLoading = false;
      return;
    }
    page++;
    state = [...state, ...newEncuestas];
    isLoading = false;
  }

  void reset() {
    state = [];
    isLoading = false;
    page = 0;
  }

  Future<void> responderEncuestaMethod(Map<String, dynamic> data) async {
    isLoading = true;
    final encuesta = await responderEncuesta(data);
    state = state.map((e) => e.id == encuesta.id ? encuesta : e).toList();
    isLoading = false;
  }

  Future<void> createEncuestaMethod(Map<String, dynamic> data) async {
    isLoading = true;
    final encuesta = await crearEncuesta(data);
    state = [encuesta, ...state];
    isLoading = false;
  }

  Future<void> deleteEncuestaMethod(int id) async {
    isLoading = true;
    final isDeleted = await encuestasRepository.deleteEncuesta(id);
    if (isDeleted) {
      state.removeWhere((e) => e.id == id);
      state = [...state];
    }
    isLoading = false;
  }
}
