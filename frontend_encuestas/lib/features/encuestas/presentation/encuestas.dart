import 'package:flutter/material.dart';

import '../../shared/shared.dart';




class EncuestaScreen extends StatelessWidget {
  const EncuestaScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu( scaffoldKey: scaffoldKey ),
      appBar: AppBar(
        title: const Text('Encuestas'),
        actions: [
          IconButton(
            onPressed: (){}, 
            icon: const Icon( Icons.search_rounded)
          )
        ],
      ),
      body: const _EncuestasView(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Nueva encuesta'),
        icon: const Icon( Icons.add ),
        onPressed: () {},
      ),
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