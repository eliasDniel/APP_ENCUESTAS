
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/domain.dart';
import 'providers.dart';

final encuestaInfoProvider =
    StateNotifierProvider.autoDispose<EncuestaInfoNotifier, Map<String, DetalleEncuesta>>((
      ref,
    ) {
      final getEncuesta = ref
          .watch(encuestasRepositoryProvider)
          .getEncuestaById;
      return EncuestaInfoNotifier(getEncuesta: getEncuesta);
    });

typedef GetDetalleEncuestaCallBack = Future<DetalleEncuesta> Function(int id);

class EncuestaInfoNotifier extends StateNotifier<Map<String, DetalleEncuesta>> {
  final GetDetalleEncuestaCallBack getEncuesta;
  bool isLoading = false;

  EncuestaInfoNotifier({required this.getEncuesta}) : super({});

  Future<void> loadEncuestaInfo(int id) async {
    if (isLoading) return;
    isLoading = true;

    if (state[id.toString()] != null) {
      isLoading = false;
      return;
    }

    final encuesta = await getEncuesta(id);
    state = {...state, id.toString(): encuesta};
    isLoading = false;
  }
}
