import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/providers.dart';
import '../../../shared/widgets/widgets.dart';
import '../providers/providers.dart';

class EncuestaScreen extends ConsumerWidget {
  const EncuestaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.watch(authProvider).user?.isAdmin ?? false;
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Encuestas'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
        ],
      ),
      body: _EncuestasView(isAdmin: isAdmin),
      floatingActionButton: isAdmin
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
  final bool isAdmin;
  const _EncuestasView({required this.isAdmin});

  @override
  _EncuestasViewState createState() => _EncuestasViewState();
}

class _EncuestasViewState extends ConsumerState<_EncuestasView> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if ((scrollController.position.pixels + 400) >=
          scrollController.position.maxScrollExtent) {
        ref.read(encuestasProvider.notifier).loadNextPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final encuestas = ref.watch(encuestasProvider);
    return encuestas.isNotEmpty
        ? ListView.builder(
            controller: scrollController,
            itemCount: encuestas.length,
            itemBuilder: (context, index) {
              final encuesta = encuestas[index];
              return CustomCardEncuesta(encuesta: encuesta);
            },
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/no_encuestas.png'),
              const SizedBox(height: 16),
              widget.isAdmin
                  ? const Text(
                      'No hay encuestas disponibles.\nCrea una nueva encuesta',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : const Text(
                      'No hay encuestas disponibles.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              const SizedBox(height: 200),
            ],
          );
  }
}
