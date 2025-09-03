import 'package:app_encuentas_prueba_tecnica/features/encuestas/infrastructure/datasource/encuesta_data_source_impl.dart';
import 'package:app_encuentas_prueba_tecnica/features/encuestas/infrastructure/repositories/encuesta_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_state_provider.dart';

final encuestasRepositoryProvider = Provider((ref) {
  final accessToken = ref.watch(authProvider).user?.token ?? '';

  return EncuestaRepositoryImpl(
    EncuestasDataSourceImpl(accessToken: accessToken),
  );
});
