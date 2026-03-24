part of 'page/relatorio_preventivas_page.dart';

enum _TipoItem {
  vencida,
  aVencer,
  concluida,
}

class _RelatorioCompleto {
  final List<Manutencao> vencidas;
  final List<Manutencao> aVencer;
  final List<Manutencao> concluidas;

  const _RelatorioCompleto({
    required this.vencidas,
    required this.aVencer,
    required this.concluidas,
  });

  int get total => vencidas.length + aVencer.length + concluidas.length;
}

class _EmptyCard extends StatelessWidget {
  final String text;

  const _EmptyCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(text),
      ),
    );
  }
}
