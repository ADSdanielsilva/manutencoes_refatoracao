import 'package:flutter/material.dart';

import '../../manutencoes_model.dart';
import 'manutencoes_form_shared_widgets.dart';

class ManutencaoFormPeriodicidadeSection extends StatelessWidget {
  final bool isMobile;
  final PeriodicidadeTipo periodicidadeTipo;
  final int intervaloValor;
  final IntervaloUnidade intervaloUnidade;
  final bool gerarSerie;
  final List<int> intervalosSugestao;
  final ValueChanged<Set<PeriodicidadeTipo>> onPeriodicidadeChanged;
  final ValueChanged<int?> onIntervaloChanged;
  final ValueChanged<IntervaloUnidade?> onUnidadeChanged;
  final ValueChanged<bool> onGerarSerieChanged;

  const ManutencaoFormPeriodicidadeSection({
    super.key,
    required this.isMobile,
    required this.periodicidadeTipo,
    required this.intervaloValor,
    required this.intervaloUnidade,
    required this.gerarSerie,
    required this.intervalosSugestao,
    required this.onPeriodicidadeChanged,
    required this.onIntervaloChanged,
    required this.onUnidadeChanged,
    required this.onGerarSerieChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: isMobile ? Alignment.centerLeft : Alignment.center,
          child: SegmentedButton<PeriodicidadeTipo>(
            segments: const [
              ButtonSegment(
                value: PeriodicidadeTipo.diaria,
                label: Text('Diária'),
                icon: Icon(Icons.today_outlined),
              ),
              ButtonSegment(
                value: PeriodicidadeTipo.periodica,
                label: Text('Periódica'),
                icon: Icon(Icons.autorenew_outlined),
              ),
            ],
            selected: {periodicidadeTipo},
            onSelectionChanged: onPeriodicidadeChanged,
          ),
        ),
        const SizedBox(height: 16),
        if (periodicidadeTipo == PeriodicidadeTipo.diaria)
          const ManutencaoFormInfoBox(
            child: Text(
              'Periodicidade diária: intervalo fixo de 1 dia.',
              style: TextStyle(color: Color(0xFF475467)),
            ),
          )
        else if (isMobile)
          _PeriodicidadeMobileFields(
            intervaloValor: intervaloValor,
            intervaloUnidade: intervaloUnidade,
            gerarSerie: gerarSerie,
            intervalosSugestao: intervalosSugestao,
            onIntervaloChanged: onIntervaloChanged,
            onUnidadeChanged: onUnidadeChanged,
            onGerarSerieChanged: onGerarSerieChanged,
          )
        else
          _PeriodicidadeDesktopFields(
            intervaloValor: intervaloValor,
            intervaloUnidade: intervaloUnidade,
            gerarSerie: gerarSerie,
            intervalosSugestao: intervalosSugestao,
            onIntervaloChanged: onIntervaloChanged,
            onUnidadeChanged: onUnidadeChanged,
            onGerarSerieChanged: onGerarSerieChanged,
          ),
      ],
    );
  }
}

class ManutencaoFormAgendamentoSection extends StatelessWidget {
  final bool editando;
  final String status;
  final DateTime? proximaData;
  final String Function(DateTime? data) formatDate;
  final VoidCallback onSelecionarData;

  const ManutencaoFormAgendamentoSection({
    super.key,
    required this.editando,
    required this.status,
    required this.proximaData,
    required this.formatDate,
    required this.onSelecionarData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onSelecionarData,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFC9D2E3)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  color: Color(0xFF344054),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Próxima data: ${formatDate(proximaData)}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF344054),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        ManutencaoFormInfoBox(
          child: Text(
            'Status atual: ${editando ? status : 'Pendente'}',
            style: const TextStyle(color: Color(0xFF475467)),
          ),
        ),
      ],
    );
  }
}

class _PeriodicidadeMobileFields extends StatelessWidget {
  final int intervaloValor;
  final IntervaloUnidade intervaloUnidade;
  final bool gerarSerie;
  final List<int> intervalosSugestao;
  final ValueChanged<int?> onIntervaloChanged;
  final ValueChanged<IntervaloUnidade?> onUnidadeChanged;
  final ValueChanged<bool> onGerarSerieChanged;

  const _PeriodicidadeMobileFields({
    required this.intervaloValor,
    required this.intervaloUnidade,
    required this.gerarSerie,
    required this.intervalosSugestao,
    required this.onIntervaloChanged,
    required this.onUnidadeChanged,
    required this.onGerarSerieChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _IntervaloDropdown(
          value: intervaloValor,
          intervalosSugestao: intervalosSugestao,
          onChanged: onIntervaloChanged,
        ),
        const SizedBox(height: 14),
        _UnidadeDropdown(
          value: intervaloUnidade,
          onChanged: onUnidadeChanged,
        ),
        const SizedBox(height: 14),
        ManutencaoFormInfoBox(
          child: SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Gerar série automática'),
            subtitle: const Text(
              'Cria ocorrências futuras para manutenções periódicas',
            ),
            value: gerarSerie,
            onChanged: onGerarSerieChanged,
          ),
        ),
      ],
    );
  }
}

class _PeriodicidadeDesktopFields extends StatelessWidget {
  final int intervaloValor;
  final IntervaloUnidade intervaloUnidade;
  final bool gerarSerie;
  final List<int> intervalosSugestao;
  final ValueChanged<int?> onIntervaloChanged;
  final ValueChanged<IntervaloUnidade?> onUnidadeChanged;
  final ValueChanged<bool> onGerarSerieChanged;

  const _PeriodicidadeDesktopFields({
    required this.intervaloValor,
    required this.intervaloUnidade,
    required this.gerarSerie,
    required this.intervalosSugestao,
    required this.onIntervaloChanged,
    required this.onUnidadeChanged,
    required this.onGerarSerieChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: _IntervaloDropdown(
            value: intervaloValor,
            intervalosSugestao: intervalosSugestao,
            onChanged: onIntervaloChanged,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          flex: 2,
          child: _UnidadeDropdown(
            value: intervaloUnidade,
            onChanged: onUnidadeChanged,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          flex: 3,
          child: ManutencaoFormInfoBox(
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Gerar série automática'),
              subtitle: const Text('Ocorrências futuras'),
              value: gerarSerie,
              onChanged: onGerarSerieChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class _IntervaloDropdown extends StatelessWidget {
  final int value;
  final List<int> intervalosSugestao;
  final ValueChanged<int?> onChanged;

  const _IntervaloDropdown({
    required this.value,
    required this.intervalosSugestao,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      initialValue: value,
      decoration: _dropdownDecoration('Intervalo'),
      items: intervalosSugestao
          .map(
            (v) => DropdownMenuItem<int>(
              value: v,
              child: Text(v.toString()),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}

class _UnidadeDropdown extends StatelessWidget {
  final IntervaloUnidade value;
  final ValueChanged<IntervaloUnidade?> onChanged;

  const _UnidadeDropdown({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<IntervaloUnidade>(
      initialValue: value,
      decoration: _dropdownDecoration('Unidade'),
      items: const [
        DropdownMenuItem(
          value: IntervaloUnidade.dias,
          child: Text('Dias'),
        ),
        DropdownMenuItem(
          value: IntervaloUnidade.meses,
          child: Text('Meses'),
        ),
        DropdownMenuItem(
          value: IntervaloUnidade.anos,
          child: Text('Anos'),
        ),
      ],
      onChanged: onChanged,
    );
  }
}

InputDecoration _dropdownDecoration(String label) {
  return InputDecoration(
    labelText: label,
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Color(0xFFC9D2E3)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: Color(0xFF4F46E5),
        width: 1.4,
      ),
    ),
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),
  );
}
