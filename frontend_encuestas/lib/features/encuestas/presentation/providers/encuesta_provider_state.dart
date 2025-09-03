// ! 2: STATENOTIFIER
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/domain.dart';
import 'encuestas_provider.dart';

// ! 1: STATENOTIFIERPROVIDE: AQUI ES DONDE VOY A USARLO EN EL FRONTEND
final encuestasProvider =
    StateNotifierProvider<EncuestasNotifier, List<Encuesta>>((ref) {
      final fetchEncuestas = ref
          .watch(encuestasRepositoryProvider)
          .getNowEncuestas;
      return EncuestasNotifier(fetchEncuestas: fetchEncuestas);
    });

typedef EncuestasCallBck = Future<List<Encuesta>> Function({int page});

class EncuestasNotifier extends StateNotifier<List<Encuesta>> {
  final EncuestasCallBck fetchEncuestas;
  EncuestasNotifier({required this.fetchEncuestas}) : super([]) {
    loadNextPage();
  }

  bool isLoading = false;
  int limit = 10;
  int page = 1;

  Future<void> loadNextPage() async {
    if (isLoading) return;
    isLoading = true;
    final newEncuestas = await fetchEncuestas(page: page);
    if (newEncuestas.isEmpty) return;
    page++;
    state = [...state, ...newEncuestas];
    isLoading = false;
  }

  void reset() {
    state = [];
    isLoading = false;
    page = 0;
  }
}
