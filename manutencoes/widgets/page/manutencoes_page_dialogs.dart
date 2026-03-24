import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_sindico/shared/models/condominio.dart';
import 'package:app_sindico/shared/models/sindico.dart';

import 'package:app_sindico/features/manutencoes/manutencoes_provider.dart';

import '../../manutencoes_form_page.dart';
import '../../manutencoes_model.dart';

Future<void> abrirFormEditarManutencao({
  required BuildContext context,
  required Manutencao manutencao,
  required Condominio condominio,
  required Sindico sindico,
}) async {
  final provider = context.read<ManutencoesProvider>();

  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ManutencaoFormPage(
        condominio: condominio,
        sindico: sindico,
        manutencao: manutencao,
      ),
    ),
  );

  if (result == true && !provider.useRealtime) {
    await provider.refresh();
  }
}

Future<bool> concluirManutencaoDialog({
  required BuildContext context,
  required Manutencao manutencao,
}) async {
  final provider = context.read<ManutencoesProvider>();
  final messenger = ScaffoldMessenger.maybeOf(context);

  final ok = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Concluir manutenção?'),
          content: Text(
            'Deseja concluir "${manutencao.titulo}"?\n\nO status será alterado automaticamente para Concluída.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Concluir'),
            ),
          ],
        ),
      ) ??
      false;

  if (!ok) return false;

  await provider.concluir(manutencao);

  if (!provider.useRealtime) {
    await provider.refresh();
  }

  messenger?.showSnackBar(
    const SnackBar(content: Text('Status alterado para Concluída')),
  );

  return true;
}

Future<void> removerManutencaoDialog({
  required BuildContext context,
  required Manutencao manutencao,
  required String condominioId,
}) async {
  final provider = context.read<ManutencoesProvider>();
  final messenger = ScaffoldMessenger.maybeOf(context);

  final ok = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Remover manutenção?'),
          content: Text('Deseja remover "${manutencao.titulo}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Remover'),
            ),
          ],
        ),
      ) ??
      false;

  if (!ok) return;

  await provider.remover(condominioId, manutencao.id);

  messenger?.showSnackBar(
    const SnackBar(content: Text('Manutenção removida')),
  );
}
