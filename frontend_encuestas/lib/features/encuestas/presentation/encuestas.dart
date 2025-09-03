import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/providers/providers.dart';
import '../../shared/shared.dart';

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
              onPressed: () {},
            )
          : null,
    );
  }
}

class _EncuestasView extends StatelessWidget {
  const _EncuestasView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Eres genial!'));
  }
}
