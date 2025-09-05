
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/providers.dart';
import '../../infrastructure/infrastructure.dart';



final encuestasRepositoryProvider = Provider((ref) {
  final accessToken = ref.watch(authProvider).user?.token ?? '';

  return EncuestaRepositoryImpl(
    EncuestasDataSourceImpl(accessToken: accessToken),
  );
});
