import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

import 'package:app_sindico/shared/models/condominio.dart';
import 'package:app_sindico/shared/models/sindico.dart';

import 'package:app_sindico/features/prestadores/prestadores_model.dart';
import 'package:app_sindico/features/prestadores/prestadores_provider.dart';
import 'package:app_sindico/features/manutencoes/preventivas/provider/page/manutencoes_provider.dart';
import '../../model/page/manutencoes_model.dart';

import '../manutencoes_form_body.dart';
import '../manutencoes_form_helpers.dart';

part '../manutencoes_form_page_prestador.dart';
part '../manutencoes_form_page_actions.dart';

class _FormBreakpoints {
  static const double mobile = 760;
  static const double desktop = 1100;
}

class ManutencaoFormPage extends StatefulWidget {
  final Condominio condominio;
  final Sindico sindico;
  final Manutencao? manutencao;

  const ManutencaoFormPage({
    super.key,
    required this.condominio,
    required this.sindico,
    this.manutencao,
  });

  @override
  State<ManutencaoFormPage> createState() => _ManutencaoFormPageState();
}

class _ManutencaoFormPageState extends State<ManutencaoFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _tituloController = TextEditingController();
  final _categoriaController = TextEditingController();
  final _observacoesController = TextEditingController();
  final _empresaController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _nomeContatoController = TextEditingController();

  final _telefoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {'#': RegExp(r'[0-9]')},
  );

  static const List<int> _intervalosSugestao = [1, 2, 3, 4, 5, 6, 12];

  bool _salvando = false;
  bool _gerarSerie = false;

  DateTime? _proximaData;
  String _status = 'Pendente';

  PeriodicidadeTipo _periodicidadeTipo = PeriodicidadeTipo.periodica;
  int _intervaloValor = 1;
  IntervaloUnidade _intervaloUnidade = IntervaloUnidade.meses;

  String? _prestadorIdSelecionado;
  String? _prestadorCategoriaSelecionada;
  String? _prestadorEmpresaSelecionada;
  String? _prestadorResponsavelSelecionado;
  String? _prestadorTelefoneSelecionado;

  bool get _editando => widget.manutencao != null;

  String get _periodicidadeLabel => manutencaoFormPeriodicidadeLabel(
        periodicidadeTipo: _periodicidadeTipo,
        intervaloValor: _intervaloValor,
        intervaloUnidade: _intervaloUnidade,
      );

  void _updateState(VoidCallback fn) {
    if (!mounted) return;
    setState(fn);
  }

  @override
  void initState() {
    super.initState();

    final m = widget.manutencao;
    if (m != null) {
      _tituloController.text = m.titulo;
      _categoriaController.text = m.categoria;
      _observacoesController.text = m.observacoes;
      _empresaController.text = m.empresa == '—' ? '' : m.empresa;
      _telefoneController.text = m.telefoneContato;
      _nomeContatoController.text = m.nomeContato;
      _proximaData = m.proximaData;
      _status = m.status;
      _periodicidadeTipo = m.periodicidadeTipo;
      _intervaloValor = m.intervaloValorNormalizado;
      _intervaloUnidade = m.intervaloUnidadeNormalizada;
      _gerarSerie = (m.seriesId ?? '').trim().isNotEmpty ||
          (m.seriesKey ?? '').trim().isNotEmpty;

      _prestadorIdSelecionado =
          (m.prestadorId ?? '').trim().isEmpty ? null : m.prestadorId!.trim();
      _prestadorCategoriaSelecionada =
          manutencaoFormNullIfEmpty(m.prestadorCategoria);
      _prestadorEmpresaSelecionada =
          manutencaoFormNullIfEmpty(m.prestadorEmpresa);
      _prestadorResponsavelSelecionado =
          manutencaoFormNullIfEmpty(m.prestadorResponsavel);
      _prestadorTelefoneSelecionado =
          manutencaoFormNullIfEmpty(m.prestadorTelefone);
    } else {
      _proximaData = DateTime.now();
      _status = 'Pendente';
      _periodicidadeTipo = PeriodicidadeTipo.periodica;
      _intervaloValor = 1;
      _intervaloUnidade = IntervaloUnidade.meses;
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _categoriaController.dispose();
    _observacoesController.dispose();
    _empresaController.dispose();
    _telefoneController.dispose();
    _nomeContatoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PrestadoresProvider()..iniciar(),
      child: Builder(
        builder: (context) {
          final width = MediaQuery.of(context).size.width;
          final isMobile = width < _FormBreakpoints.mobile;
          final isTablet = width >= _FormBreakpoints.mobile &&
              width < _FormBreakpoints.desktop;

          final prestadoresProvider = context.watch<PrestadoresProvider>();
          final prestadoresFiltrados = prestadoresProvider.filtrarPorCategoria(
            _categoriaController.text.trim(),
          );

          _validarPrestadorSelecionado(prestadoresProvider);

          return Scaffold(
            backgroundColor: const Color(0xFFF5F7FB),
            appBar: AppBar(
              title: Text(_editando ? 'Editar manutenção' : 'Nova manutenção'),
              centerTitle: false,
            ),
            body: ManutencaoFormBody(
              formKey: _formKey,
              isMobile: isMobile,
              isTablet: isTablet,
              editando: _editando,
              salvando: _salvando,
              gerarSerie: _gerarSerie,
              status: _status,
              proximaData: _proximaData,
              condominio: widget.condominio,
              prestadoresProvider: prestadoresProvider,
              prestadoresFiltrados: prestadoresFiltrados,
              prestadorIdSelecionado: _prestadorIdSelecionado,
              tituloController: _tituloController,
              categoriaController: _categoriaController,
              observacoesController: _observacoesController,
              empresaController: _empresaController,
              nomeContatoController: _nomeContatoController,
              telefoneController: _telefoneController,
              telefoneInputFormatters: [_telefoneMask],
              periodicidadeTipo: _periodicidadeTipo,
              intervaloValor: _intervaloValor,
              intervaloUnidade: _intervaloUnidade,
              intervalosSugestao: _intervalosSugestao,
              formatDate: manutencaoFormFormatDate,
              onCategoriaChanged: (_) =>
                  _onCategoriaChanged(prestadoresProvider),
              onLimparPrestadorSelecionado: () {
                _updateState(() {
                  _limparPrestadorSelecionado();
                });
              },
              onAplicarPrestador: _aplicarPrestador,
              onPeriodicidadeChanged: (value) {
                _updateState(() {
                  _periodicidadeTipo = value.first;
                  if (_periodicidadeTipo == PeriodicidadeTipo.diaria) {
                    _intervaloValor = 1;
                    _intervaloUnidade = IntervaloUnidade.dias;
                    _gerarSerie = false;
                  }
                });
              },
              onIntervaloChanged: (v) {
                if (v == null) return;
                _updateState(() => _intervaloValor = v);
              },
              onUnidadeChanged: (v) {
                if (v == null) return;
                _updateState(() => _intervaloUnidade = v);
              },
              onGerarSerieChanged: (v) {
                _updateState(() => _gerarSerie = v);
              },
              onSelecionarData: _selecionarData,
              onCancelar: () => Navigator.pop(context),
              onSalvar: _salvar,
            ),
          );
        },
      ),
    );
  }
}
