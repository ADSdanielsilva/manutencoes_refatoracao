import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_sindico/features/prestadores/prestadores_model.dart';
import 'package:app_sindico/features/prestadores/prestadores_provider.dart';

import 'manutencoes_form_shared_widgets.dart';

class ManutencaoFormPrimaryFields extends StatelessWidget {
  final bool isMobile;
  final TextEditingController tituloController;
  final TextEditingController categoriaController;
  final TextEditingController observacoesController;
  final void Function(String)? onCategoriaChanged;

  const ManutencaoFormPrimaryFields({
    super.key,
    required this.isMobile,
    required this.tituloController,
    required this.categoriaController,
    required this.observacoesController,
    this.onCategoriaChanged,
  });

  @override
  Widget build(BuildContext context) {
    final categoriaField = ManutencaoFormTextField(
      controller: categoriaController,
      label: 'Categoria da manutenção',
      hint: 'Ex.: Elétrica, Hidráulica, Limpeza',
      validator: (v) {
        if ((v ?? '').trim().isEmpty) {
          return 'Informe a categoria';
        }
        return null;
      },
      onChanged: onCategoriaChanged,
    );

    final tituloField = ManutencaoFormTextField(
      controller: tituloController,
      label: 'Título / serviço',
      hint: 'Ex.: Limpeza da caixa d’água',
      validator: (v) {
        if ((v ?? '').trim().isEmpty) {
          return 'Informe o título';
        }
        return null;
      },
    );

    final observacoesField = ManutencaoFormTextField(
      controller: observacoesController,
      label: 'Observações',
      hint: 'Detalhes da manutenção',
      maxLines: 4,
    );

    if (isMobile) {
      return Column(
        children: [
          tituloField,
          const SizedBox(height: 14),
          categoriaField,
          const SizedBox(height: 14),
          observacoesField,
        ],
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(flex: 6, child: tituloField),
            const SizedBox(width: 14),
            Expanded(flex: 5, child: categoriaField),
          ],
        ),
        const SizedBox(height: 14),
        observacoesField,
      ],
    );
  }
}

class ManutencaoFormPrestadorSelector extends StatelessWidget {
  final bool isMobile;
  final String categoriaAtual;
  final String? prestadorIdSelecionado;
  final List<Prestador> prestadoresFiltrados;
  final PrestadoresProvider provider;
  final VoidCallback onLimparPrestadorSelecionado;
  final void Function(Prestador? prestador) onAplicarPrestador;

  const ManutencaoFormPrestadorSelector({
    super.key,
    required this.isMobile,
    required this.categoriaAtual,
    required this.prestadorIdSelecionado,
    required this.prestadoresFiltrados,
    required this.provider,
    required this.onLimparPrestadorSelecionado,
    required this.onAplicarPrestador,
  });

  @override
  Widget build(BuildContext context) {
    final hasPrestadorSelecionado = (prestadorIdSelecionado ?? '').isNotEmpty;
    final prestadorSelecionado = provider.porId(prestadorIdSelecionado);

    final itens = <DropdownMenuItem<String?>>[
      const DropdownMenuItem<String?>(
        value: null,
        child: Text('Nenhum prestador selecionado'),
      ),
      ...prestadoresFiltrados.map(
        (p) => DropdownMenuItem<String?>(
          value: p.id,
          child: Text(
            p.labelSecundaria.isEmpty
                ? p.labelPrincipal
                : '${p.labelPrincipal} — ${p.labelSecundaria}',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String?>(
          initialValue: hasPrestadorSelecionado &&
                  provider.porId(prestadorIdSelecionado) != null
              ? prestadorIdSelecionado
              : null,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'Prestador cadastrado',
            hintText: 'Selecione um prestador',
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
          ),
          items: itens,
          onChanged: provider.loading
              ? null
              : (value) {
                  if (value == null || value.trim().isEmpty) {
                    onLimparPrestadorSelecionado();
                    return;
                  }

                  final prestador = provider.porId(value);
                  onAplicarPrestador(prestador);
                },
        ),
        const SizedBox(height: 12),
        ManutencaoFormInfoBox(
          child: provider.loading
              ? const Row(
                  children: [
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text('Carregando prestadores cadastrados...'),
                    ),
                  ],
                )
              : provider.erro != null
                  ? Text('Erro ao carregar prestadores: ${provider.erro}')
                  : Text(
                      categoriaAtual.isEmpty
                          ? 'Sem categoria informada, a lista mostra todos os prestadores cadastrados.'
                          : prestadoresFiltrados.isEmpty
                              ? 'Nenhum prestador compatível com a categoria "$categoriaAtual".'
                              : '${prestadoresFiltrados.length} prestador(es) compatível(is) com a categoria "$categoriaAtual".',
                      style: const TextStyle(
                        color: Color(0xFF475467),
                        height: 1.3,
                      ),
                    ),
        ),
        if (!isMobile && prestadorSelecionado != null) ...[
          const SizedBox(height: 12),
          ManutencaoFormInfoBox(
            background: const Color(0xFFF5F3FF),
            border: const Color(0xFFE3DDFC),
            child: Text(
              'Prestador selecionado: ${prestadorSelecionado.empresa} • ${prestadorSelecionado.responsavel}',
              style: const TextStyle(
                color: Color(0xFF4F46E5),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class ManutencaoFormContatoFields extends StatelessWidget {
  final bool isMobile;
  final TextEditingController empresaController;
  final TextEditingController nomeContatoController;
  final TextEditingController telefoneController;
  final List<TextInputFormatter>? telefoneInputFormatters;

  const ManutencaoFormContatoFields({
    super.key,
    required this.isMobile,
    required this.empresaController,
    required this.nomeContatoController,
    required this.telefoneController,
    this.telefoneInputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    final empresaField = ManutencaoFormTextField(
      controller: empresaController,
      label: 'Empresa',
      hint: 'Ex.: Eletro Forte',
    );

    final nomeField = ManutencaoFormTextField(
      controller: nomeContatoController,
      label: 'Nome do contato',
      hint: 'Ex.: Daniel',
    );

    final telefoneField = ManutencaoFormTextField(
      controller: telefoneController,
      label: 'Telefone',
      hint: '(00) 00000-0000',
      keyboardType: TextInputType.phone,
      inputFormatters: telefoneInputFormatters,
    );

    if (isMobile) {
      return Column(
        children: [
          empresaField,
          const SizedBox(height: 14),
          nomeField,
          const SizedBox(height: 14),
          telefoneField,
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: empresaField),
        const SizedBox(width: 14),
        Expanded(child: nomeField),
        const SizedBox(width: 14),
        Expanded(child: telefoneField),
      ],
    );
  }
}

class ManutencaoFormActionBar extends StatelessWidget {
  final bool isMobile;
  final bool salvando;
  final bool editando;
  final VoidCallback onCancelar;
  final VoidCallback onSalvar;

  const ManutencaoFormActionBar({
    super.key,
    required this.isMobile,
    required this.salvando,
    required this.editando,
    required this.onCancelar,
    required this.onSalvar,
  });

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: salvando ? null : onCancelar,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Cancelar'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: salvando ? null : onSalvar,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: salvando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(editando ? 'Salvar alterações' : 'Salvar'),
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: salvando ? null : onCancelar,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(120, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text('Cancelar'),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: salvando ? null : onSalvar,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(180, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          icon: salvando
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.save_outlined),
          label: Text(editando ? 'Salvar alterações' : 'Salvar'),
        ),
      ],
    );
  }
}
