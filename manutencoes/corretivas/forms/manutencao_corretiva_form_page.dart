import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/manutencao_corretiva.dart';
import '../provider/manutencoes_corretivas_provider.dart';

class ManutencaoCorretivaFormPage extends StatefulWidget {
  final ManutencaoCorretiva? item;

  const ManutencaoCorretivaFormPage({
    super.key,
    this.item,
  });

  @override
  State<ManutencaoCorretivaFormPage> createState() =>
      _ManutencaoCorretivaFormPageState();
}

class _ManutencaoCorretivaFormPageState
    extends State<ManutencaoCorretivaFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();

  bool get _isEdicao => widget.item != null;

  @override
  void initState() {
    super.initState();

    final item = widget.item;
    if (item != null) {
      _tituloController.text = item.titulo;
      _descricaoController.text = item.descricao ?? '';
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  void _salvar() {
    final formValido = _formKey.currentState?.validate() ?? false;
    if (!formValido) return;

    final provider = context.read<ManutencoesCorretivasProvider>();
    final descricao = _descricaoController.text.trim();

    if (_isEdicao) {
      final atual = widget.item!;

      provider.atualizar(
        atual.copyWith(
          titulo: _tituloController.text.trim(),
          descricao: descricao.isEmpty ? atual.descricao : descricao,
        ),
      );
    } else {
      final item = ManutencaoCorretiva(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        titulo: _tituloController.text.trim(),
        descricao: descricao.isEmpty ? null : descricao,
        status: ManutencaoCorretivaStatus.aberta,
        prioridade: ManutencaoCorretivaPrioridade.media,
        custo: 0,
        dataAbertura: DateTime.now(),
      );

      provider.adicionar(item);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdicao ? 'Editar corretiva' : 'Nova corretiva'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isEdicao
                        ? 'Editar manutenção corretiva'
                        : 'Cadastrar manutenção corretiva',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _tituloController,
                    decoration: const InputDecoration(
                      labelText: 'Título',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      final texto = value?.trim() ?? '';
                      if (texto.isEmpty) {
                        return 'Informe o título';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descricaoController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Descrição',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton(
                      onPressed: _salvar,
                      child: Text(_isEdicao ? 'Atualizar' : 'Salvar'),
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
