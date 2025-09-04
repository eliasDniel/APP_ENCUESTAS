import 'package:app_encuentas_prueba_tecnica/features/shared/widgets/custom_card_encuesta.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/providers.dart';
import '../../../shared/shared.dart';
import '../providers/encuesta_provider_state.dart';

class EncuestaScreen extends ConsumerStatefulWidget {
  const EncuestaScreen({super.key});

  @override
  EncuestaScreenState createState() => EncuestaScreenState();
}

class EncuestaScreenState extends ConsumerState<EncuestaScreen> {
  @override
  Widget build(BuildContext context) {
    final isAdmin = ref.watch(authProvider).user?.isAdmin ?? false;
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        title: const Text('Encuestas'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
        ],
      ),
      body: const _EncuestasView(),
      floatingActionButton: !isAdmin
          ? FloatingActionButton.extended(
              label: const Text('Nueva encuesta'),
              icon: const Icon(Icons.add),
              onPressed: () {
                context.push('/create-encuesta');
              },
            )
          : null,
    );
  }
}

class _EncuestasView extends ConsumerStatefulWidget {
  const _EncuestasView();

  @override
  _EncuestasViewState createState() => _EncuestasViewState();
}

class _EncuestasViewState extends ConsumerState<_EncuestasView> {
  
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    
    scrollController.addListener(() {
      if ( (scrollController.position.pixels + 400) >= scrollController.position.maxScrollExtent ) {
        ref.read(encuestasProvider.notifier).loadNextPage();
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    final encuestas = ref.watch(encuestasProvider);
    return ListView.builder(
      controller: scrollController,
      itemCount: encuestas.length,
      itemBuilder: (context, index) {
        final encuesta = encuestas[index];
        return CustomCardEncuesta(
          encuesta: encuesta,
        );
      },
    );
  }
}
