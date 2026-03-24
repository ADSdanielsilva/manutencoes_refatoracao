import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_sindico/shared/formatters/br_phone_formatter.dart';
import 'package:app_sindico/shared/models/condominio.dart';
import 'package:app_sindico/shared/models/sindico.dart';

import '../../model/page/manutencoes_model.dart';
import 'package:app_sindico/features/manutencoes/preventivas/provider/page/manutencoes_provider.dart';
import 'manutencoes_page_cards.dart';
import 'manutencoes_page_constants.dart';
import 'manutencoes_page_dialogs.dart';
import 'manutencoes_page_filters.dart';
import 'manutencoes_page_states.dart';

part 'manutencoes_page_list_helpers.dart';

class ManutencaoLista extends StatefulWidget {
  final ManutencaoTabMain tab;
  final Sindico sindico;
  final Condominio condominio;

  const ManutencaoLista({
    super.key,
    required this.tab,
    required this.sindico,
    required this.condominio,
  });

  @override
  State<ManutencaoLista> createState() => _ManutencaoListaState();
}

class _ManutencaoListaState extends State<ManutencaoLista> {
  int? _mesFiltro;
  int? _anoFiltro;
  String _periodicidadeFiltro = 'mensal';
  String _busca = '';

  final Map<String, String> _statusOverrides = {};
  final BrPhoneFormatter _brPhone = BrPhoneFormatter();

  static const _meses = <int, String>{
    1: 'Janeiro',
    2: 'Fevereiro',
    3: 'Março',
    4: 'Abril',
    5: 'Maio',
    6: 'Junho',
    7: 'Julho',
    8: 'Agosto',
    9: 'Setembro',
    10: 'Outubro',
    11: 'Novembro',
    12: 'Dezembro',
  };

  Widget _buildCard(BuildContext context, Manutencao m) {
    final d = m.proximaData;
    final contatoTxt = _contatoTexto(m);
    final prestadorLinha = _prestadorLinha(m);
    final showLegacyEmpresaContato = prestadorLinha == null &&
        (m.empresa.trim().isNotEmpty || contatoTxt.trim().isNotEmpty);
    final isSerie = (m.seriesId ?? '').trim().isNotEmpty ||
        (m.seriesKey ?? '').trim().isNotEmpty;
    final concluida = _isConcluida(m);

    return ManutencaoCard(
      manutencao: m,
      statusLabel: _statusEfetivo(m),
      dataFormatada: d == null ? '(sem data)' : _formatDMY(d),
      statusColor: _statusColor(m),
      prestadorLinha: prestadorLinha,
      contatoTexto: contatoTxt,
      showLegacyEmpresaContato: showLegacyEmpresaContato,
      isSerie: isSerie,
      onTap: () => abrirFormEditarManutencao(
        context: context,
        manutencao: m,
        condominio: widget.condominio,
        sindico: widget.sindico,
      ),
      onEditar: () => abrirFormEditarManutencao(
        context: context,
        manutencao: m,
        condominio: widget.condominio,
        sindico: widget.sindico,
      ),
      onConcluir: concluida
          ? null
          : () async {
              setState(() {
                _statusOverrides[m.id] = 'Concluída';
              });

              try {
                await concluirManutencaoDialog(
                  context: context,
                  manutencao: m,
                );
              } catch (e) {
                setState(() {
                  _statusOverrides.remove(m.id);
                });

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao concluir manutenção: $e')),
                  );
                }
              }
            },
      onExcluir: () async {
        await removerManutencaoDialog(
          context: context,
          manutencao: m,
          condominioId: widget.condominio.id,
        );

        if (mounted) {
          setState(() {
            _statusOverrides.remove(m.id);
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ManutencoesProvider>();
    final lista = _filtrarLista(provider);
    final grupos = _agruparLista(lista);
    final ordem = _ordemGruposParaAba();
    final gruposNaoVazios =
        ordem.where((key) => (grupos[key] ?? const []).isNotEmpty).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FiltrosManutencao(
          labelAba: _labelAba,
          busca: _busca,
          mesFiltro: _mesFiltro,
          anoFiltro: _anoFiltro,
          meses: _meses,
          anosSugestao: _anosSugestao(),
          onBuscaChanged: (v) => setState(() => _busca = v),
          onMesChanged: (v) => setState(() => _mesFiltro = v),
          onAnoChanged: (v) => setState(() => _anoFiltro = v),
          onLimpar: () {
            setState(() {
              _busca = '';
              _mesFiltro = null;
              _anoFiltro = null;
              _periodicidadeFiltro = 'mensal';
            });
          },
        ),
        if (widget.tab == ManutencaoTabMain.periodica) ...[
          const SizedBox(height: 12),
          PeriodicidadeSelector(
            value: _periodicidadeFiltro,
            onChanged: (value) {
              setState(() {
                _periodicidadeFiltro = value;
              });
            },
          ),
        ],
        const SizedBox(height: 14),
        if (lista.isEmpty)
          EmptyStateLista(
            labelAba: widget.tab == ManutencaoTabMain.periodica
                ? _tituloGrupo(_periodicidadeFiltro)
                : _labelAba,
          )
        else if (widget.tab == ManutencaoTabMain.diaria ||
            widget.tab == ManutencaoTabMain.periodica)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SecaoPeriodicidadeHeader(
                titulo: widget.tab == ManutencaoTabMain.diaria
                    ? 'Diárias'
                    : _tituloGrupo(_periodicidadeFiltro),
                quantidade: lista.length,
                color: widget.tab == ManutencaoTabMain.diaria
                    ? ManutencoesUiColors.diaria
                    : ManutencoesUiColors.periodica,
              ),
              const SizedBox(height: 10),
              for (final m in lista) _buildCard(context, m),
            ],
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final grupoKey in gruposNaoVazios) ...[
                SecaoPeriodicidadeHeader(
                  titulo: _tituloGrupo(grupoKey),
                  quantidade: grupos[grupoKey]!.length,
                  color: grupoKey == 'diaria'
                      ? ManutencoesUiColors.diaria
                      : ManutencoesUiColors.periodica,
                ),
                const SizedBox(height: 10),
                for (final m in grupos[grupoKey]!) _buildCard(context, m),
                const SizedBox(height: 6),
              ],
            ],
          ),
      ],
    );
  }
}
