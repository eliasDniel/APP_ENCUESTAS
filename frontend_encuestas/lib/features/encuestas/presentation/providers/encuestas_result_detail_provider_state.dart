






import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/domain.dart';
import 'encuestas_provider.dart';



final encuestasResultDetailProvider =
    StateNotifierProvider.autoDispose<EncuestasResultInfoNotifier, Map<String, EncuestasResultDetail>>((
      ref,
    ) {
      final getResultadosEncuesta = ref
          .watch(encuestasRepositoryProvider)
          .getResultadosEncuestaById;
      return EncuestasResultInfoNotifier(getResulEncuesta: getResultadosEncuesta);
    });


typedef GetResultEncuestaCallBack = Future<EncuestasResultDetail> Function(int id);

class EncuestasResultInfoNotifier extends StateNotifier<Map<String, EncuestasResultDetail>> {
  final GetResultEncuestaCallBack getResulEncuesta;
  bool isLoading = false;

  EncuestasResultInfoNotifier({required this.getResulEncuesta}) : super({});

  Future<void> loadResultEncuesta(int id) async {
    if (isLoading) return;
    isLoading = true;

    if (state[id.toString()] != null) {
      isLoading = false;
      return;
    }

    final encuesta = await getResulEncuesta(id);
    state = {...state, id.toString(): encuesta};
    isLoading = false;
  }
}
