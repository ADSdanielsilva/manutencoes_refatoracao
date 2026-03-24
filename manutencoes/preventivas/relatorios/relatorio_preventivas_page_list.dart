part of 'page/relatorio_preventivas_page.dart';

mixin _Relatorio30DiasPageListMixin
    on _Relatorio30DiasPageBaseMixin, _Relatorio30DiasPageHelpersMixin {
  Widget _buildSectionTitle(String title, int count) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        Chip(label: Text('$count')),
      ],
    );
  }

  Widget _itemTile(
    Manutencao m, {
    required _TipoItem tipo,
  }) {
    final dataStr = _fmtDate(m.proximaData);
    final status = _statusDisplay(m.status);

    final empresa = _safeString(_readField(m, ['empresa']));
    final contato = _safeString(_readField(m, ['contato']));

    IconData icon;
    Color? color;

    switch (tipo) {
      case _TipoItem.vencida:
        icon = Icons.warning_amber_rounded;
        color = Colors.orange;
        break;
      case _TipoItem.aVencer:
        icon = Icons.schedule;
        color = Colors.blue;
        break;
      case _TipoItem.concluida:
        icon = Icons.check_circle;
        color = Colors.green;
        break;
    }

    final subtitle = [
      'Próxima: $dataStr',
      if (empresa.isNotEmpty) 'Empresa: $empresa',
      if (contato.isNotEmpty) 'Contato: $contato',
      if (status.isNotEmpty) 'Status: $status',
    ].join(' - ');

    return Card(
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(_tituloManutencao(m)),
        subtitle: Text(subtitle),
      ),
    );
  }
}
