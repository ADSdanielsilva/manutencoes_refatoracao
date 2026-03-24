import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app_sindico/shared/models/condominio.dart';
import 'package:app_sindico/features/prestadores/prestadores_model.dart';
import 'package:app_sindico/features/prestadores/prestadores_provider.dart';
import 'package:app_sindico/features/manutencoes/manutencoes_model.dart';
import 'manutencoes_form_basic_sections.dart';
import 'manutencoes_form_schedule_sections.dart';
import 'manutencoes_form_shared_widgets.dart';

class ManutencaoFormBody extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final bool isMobile;
  final bool isTablet;
  final bool editando;
  final bool salvando;
  final bool gerarSerie;
  final String status;
  final DateTime? proximaData;
  final Condominio condominio;
  final PrestadoresProvider prestadoresProvider;
  final List<Prestador> prestadoresFiltrados;
  final String? prestadorIdSelecionado;
  final TextEditingController tituloController;
  final TextEditingController categoriaController;
  final TextEditingController observacoesController;
  final TextEditingController empresaController;
  final TextEditingController nomeContatoController;
  final TextEditingController telefoneController;
  final List<TextInputFormatter> telefoneInputFormatters;
  final PeriodicidadeTipo periodicidadeTipo;
  final int intervaloValor;
  final IntervaloUnidade intervaloUnidade;
  final List<int> intervalosSugestao;
  final String Function(DateTime?) formatDate;
  final ValueChanged<String> onCategoriaChanged;
  final VoidCallback onLimparPrestadorSelecionado;
  final void Function(Prestador? prestador) onAplicarPrestador;
  final ValueChanged<Set<PeriodicidadeTipo>> onPeriodicidadeChanged;
  final ValueChanged<int?> onIntervaloChanged;
  final ValueChanged<IntervaloUnidade?> onUnidadeChanged;
  final ValueChanged<bool> onGerarSerieChanged;
  final VoidCallback onSelecionarData;
  final VoidCallback onCancelar;
  final VoidCallback onSalvar;

  const ManutencaoFormBody({
    super.key,
    required this.formKey,
    required this.isMobile,
    required this.isTablet,
    required this.editando,
    required this.salvando,
    required this.gerarSerie,
    required this.status,
    required this.proximaData,
    required this.condominio,
    required this.prestadoresProvider,
    required this.prestadoresFiltrados,
    required this.prestadorIdSelecionado,
    required this.tituloController,
    required this.categoriaController,
    required this.observacoesController,
    required this.empresaController,
    required this.nomeContatoController,
    required this.telefoneController,
    required this.telefoneInputFormatters,
    required this.periodicidadeTipo,
    required this.intervaloValor,
    required this.intervaloUnidade,
    required this.intervalosSugestao,
    required this.formatDate,
    required this.onCategoriaChanged,
    required this.onLimparPrestadorSelecionado,
    required this.onAplicarPrestador,
    required this.onPeriodicidadeChanged,
    required this.onIntervaloChanged,
    required this.onUnidadeChanged,
    required this.onGerarSerieChanged,
    required this.onSelecionarData,
    required this.onCancelar,
    required this.onSalvar,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = isMobile ? 12.0 : 14.0;
    final headerTitle = editando ? 'Editar manutenção' : 'Nova manutenção';
    final headerSubtitle = editando
        ? 'Atualize os dados da manutenção, ajuste a periodicidade e vincule um prestador compatível.'
        : 'Cadastre uma nova manutenção diária ou periódica e vincule um prestador compatível ao serviço.';

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          14,
          horizontalPadding,
          24,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isMobile
                  ? double.infinity
                  : isTablet
                      ? 880
                      : 1120,
            ),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  ManutencaoFormPageHeader(
                    isMobile: isMobile,
                    condominioNome: condominio.nome,
                    title: headerTitle,
                    subtitle: headerSubtitle,
                  ),
                  const SizedBox(height: 14),
                  ManutencaoFormSectionCard(
                    title: 'Dados principais',
                    icon: Icons.build_circle_outlined,
                    iconBg: const Color(0xFFEDE9FE),
                    iconColor: const Color(0xFF7C3AED),
                    child: ManutencaoFormPrimaryFields(
                      isMobile: isMobile,
                      tituloController: tituloController,
                      categoriaController: categoriaController,
                      observacoesController: observacoesController,
                      onCategoriaChanged: onCategoriaChanged,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ManutencaoFormSectionCard(
                    title: 'Contato / responsável',
                    icon: Icons.business_center_outlined,
                    iconBg: const Color(0xFFDBEAFE),
                    iconColor: const Color(0xFF2563EB),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ManutencaoFormPrestadorSelector(
                          isMobile: isMobile,
                          categoriaAtual: categoriaController.text.trim(),
                          prestadorIdSelecionado: prestadorIdSelecionado,
                          prestadoresFiltrados: prestadoresFiltrados,
                          provider: prestadoresProvider,
                          onLimparPrestadorSelecionado:
                              onLimparPrestadorSelecionado,
                          onAplicarPrestador: onAplicarPrestador,
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: onLimparPrestadorSelecionado,
                            icon: const Icon(Icons.link_off_outlined),
                            label: const Text('Desvincular prestador'),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ManutencaoFormContatoFields(
                          isMobile: isMobile,
                          empresaController: empresaController,
                          nomeContatoController: nomeContatoController,
                          telefoneController: telefoneController,
                          telefoneInputFormatters: telefoneInputFormatters,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  ManutencaoFormSectionCard(
                    title: 'Periodicidade',
                    icon: Icons.autorenew_outlined,
                    iconBg: const Color(0xFFFEF3C7),
                    iconColor: const Color(0xFFF59E0B),
                    child: ManutencaoFormPeriodicidadeSection(
                      isMobile: isMobile,
                      periodicidadeTipo: periodicidadeTipo,
                      intervaloValor: intervaloValor,
                      intervaloUnidade: intervaloUnidade,
                      gerarSerie: gerarSerie,
                      intervalosSugestao: intervalosSugestao,
                      onPeriodicidadeChanged: onPeriodicidadeChanged,
                      onIntervaloChanged: onIntervaloChanged,
                      onUnidadeChanged: onUnidadeChanged,
                      onGerarSerieChanged: onGerarSerieChanged,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ManutencaoFormSectionCard(
                    title: 'Agendamento',
                    icon: Icons.event_outlined,
                    iconBg: const Color(0xFFFEF3C7),
                    iconColor: const Color(0xFFF59E0B),
                    child: ManutencaoFormAgendamentoSection(
                      editando: editando,
                      status: status,
                      proximaData: proximaData,
                      formatDate: formatDate,
                      onSelecionarData: onSelecionarData,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ManutencaoFormSectionCard(
                    title: 'Ações',
                    icon: Icons.task_alt_outlined,
                    iconBg: const Color(0xFFDCFCE7),
                    iconColor: const Color(0xFF22C55E),
                    child: ManutencaoFormActionBar(
                      isMobile: isMobile,
                      salvando: salvando,
                      editando: editando,
                      onCancelar: onCancelar,
                      onSalvar: onSalvar,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
