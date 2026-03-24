import 'package:flutter/material.dart';

import 'manutencoes_page_constants.dart';

class FiltrosManutencao extends StatelessWidget {
  final String labelAba;
  final String busca;
  final int? mesFiltro;
  final int? anoFiltro;
  final Map<int, String> meses;
  final List<int> anosSugestao;
  final ValueChanged<String> onBuscaChanged;
  final ValueChanged<int?> onMesChanged;
  final ValueChanged<int?> onAnoChanged;
  final VoidCallback onLimpar;

  const FiltrosManutencao({
    super.key,
    required this.labelAba,
    required this.busca,
    required this.mesFiltro,
    required this.anoFiltro,
    required this.meses,
    required this.anosSugestao,
    required this.onBuscaChanged,
    required this.onMesChanged,
    required this.onAnoChanged,
    required this.onLimpar,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 860;

    return Container(
      decoration: BoxDecoration(
        color: ManutencoesUiColors.cardBackground,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: ManutencoesUiColors.border),
      ),
      child: Padding(
        padding: EdgeInsets.all(width < 480 ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  'Lista • $labelAba',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: ManutencoesUiColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'Filtros',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: ManutencoesUiColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (isCompact)
              Column(
                children: [
                  BuscaField(busca: busca, onChanged: onBuscaChanged),
                  const SizedBox(height: 10),
                  MesDropdown(
                    meses: meses,
                    value: mesFiltro,
                    onChanged: onMesChanged,
                  ),
                  const SizedBox(height: 10),
                  AnoDropdown(
                    anosSugestao: anosSugestao,
                    value: anoFiltro,
                    onChanged: onAnoChanged,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: onLimpar,
                      icon: const Icon(Icons.filter_alt_off),
                      label: const Text('Limpar filtros'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: width < 980 ? double.infinity : 280,
                    child: BuscaField(
                      busca: busca,
                      onChanged: onBuscaChanged,
                    ),
                  ),
                  SizedBox(
                    width: 220,
                    child: MesDropdown(
                      meses: meses,
                      value: mesFiltro,
                      onChanged: onMesChanged,
                    ),
                  ),
                  SizedBox(
                    width: 220,
                    child: AnoDropdown(
                      anosSugestao: anosSugestao,
                      value: anoFiltro,
                      onChanged: onAnoChanged,
                    ),
                  ),
                  SizedBox(
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: onLimpar,
                      icon: const Icon(Icons.filter_alt_off),
                      label: const Text('Limpar filtros'),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class BuscaField extends StatelessWidget {
  final String busca;
  final ValueChanged<String> onChanged;

  const BuscaField({
    super.key,
    required this.busca,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: ValueKey('busca_$busca'),
      initialValue: busca,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: 'Buscar',
        hintText: 'Título, status, periodicidade...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        isDense: true,
      ),
    );
  }
}

class MesDropdown extends StatelessWidget {
  final Map<int, String> meses;
  final int? value;
  final ValueChanged<int?> onChanged;

  const MesDropdown({
    super.key,
    required this.meses,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int?>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: 'Mês',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        isDense: true,
      ),
      items: [
        const DropdownMenuItem<int?>(
          value: null,
          child: Text('Todos'),
        ),
        ...meses.entries.map(
          (e) => DropdownMenuItem<int?>(
            value: e.key,
            child: Text(e.value),
          ),
        ),
      ],
      onChanged: onChanged,
    );
  }
}

class AnoDropdown extends StatelessWidget {
  final List<int> anosSugestao;
  final int? value;
  final ValueChanged<int?> onChanged;

  const AnoDropdown({
    super.key,
    required this.anosSugestao,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int?>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: 'Ano',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        isDense: true,
      ),
      items: [
        const DropdownMenuItem<int?>(
          value: null,
          child: Text('Todos'),
        ),
        ...anosSugestao.map(
          (y) => DropdownMenuItem<int?>(
            value: y,
            child: Text(y.toString()),
          ),
        ),
      ],
      onChanged: onChanged,
    );
  }
}

class PeriodicidadeSelector extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const PeriodicidadeSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const opcoes = [
      ('mensal', 'Mensal'),
      ('trimestral', 'Trimestral'),
      ('semestral', 'Semestral'),
      ('anual', 'Anual'),
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ManutencoesUiColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ManutencoesUiColors.border),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: opcoes.map((item) {
          final selected = value == item.$1;

          return ChoiceChip(
            label: Text(item.$2),
            selected: selected,
            onSelected: (_) => onChanged(item.$1),
            labelStyle: TextStyle(
              color: selected ? Colors.white : ManutencoesUiColors.periodica,
              fontWeight: FontWeight.w700,
            ),
            selectedColor: ManutencoesUiColors.periodica,
            backgroundColor:
                ManutencoesUiColors.periodica.withValues(alpha: 0.08),
            side: BorderSide(
              color: selected
                  ? ManutencoesUiColors.periodica
                  : ManutencoesUiColors.periodica.withValues(alpha: 0.22),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
          );
        }).toList(),
      ),
    );
  }
}
