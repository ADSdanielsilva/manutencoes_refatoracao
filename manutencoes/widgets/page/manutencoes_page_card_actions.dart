import 'package:flutter/material.dart';

import 'manutencoes_page_constants.dart';

class ManutencaoCardActions extends StatelessWidget {
  final bool isCompact;
  final bool concluida;
  final VoidCallback onEditar;
  final VoidCallback? onConcluir;
  final VoidCallback onExcluir;

  const ManutencaoCardActions({
    super.key,
    required this.isCompact,
    required this.concluida,
    required this.onEditar,
    required this.onConcluir,
    required this.onExcluir,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return _CompactManutencaoCardActions(
        concluida: concluida,
        onEditar: onEditar,
        onConcluir: onConcluir,
        onExcluir: onExcluir,
      );
    }

    return _DesktopManutencaoCardActions(
      concluida: concluida,
      onEditar: onEditar,
      onConcluir: onConcluir,
      onExcluir: onExcluir,
    );
  }
}

class _CompactManutencaoCardActions extends StatelessWidget {
  final bool concluida;
  final VoidCallback onEditar;
  final VoidCallback? onConcluir;
  final VoidCallback onExcluir;

  const _CompactManutencaoCardActions({
    required this.concluida,
    required this.onEditar,
    required this.onConcluir,
    required this.onExcluir,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _CompactActionButton(
            onPressed: onEditar,
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text(
              'Editar',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _CompactActionButton(
            onPressed: onConcluir,
            icon: Icon(
              concluida ? Icons.check_circle : Icons.check_circle_outline,
              size: 18,
            ),
            label: Text(
              concluida ? 'Concluída' : 'Concluir',
              overflow: TextOverflow.ellipsis,
            ),
            foregroundColor: ManutencoesUiColors.statusConcluida,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _CompactActionButton(
            onPressed: onExcluir,
            icon: const Icon(Icons.delete_outline, size: 18),
            label: const Text(
              'Excluir',
              overflow: TextOverflow.ellipsis,
            ),
            foregroundColor: ManutencoesUiColors.statusVencida,
          ),
        ),
      ],
    );
  }
}

class _DesktopManutencaoCardActions extends StatelessWidget {
  final bool concluida;
  final VoidCallback onEditar;
  final VoidCallback? onConcluir;
  final VoidCallback onExcluir;

  const _DesktopManutencaoCardActions({
    required this.concluida,
    required this.onEditar,
    required this.onConcluir,
    required this.onExcluir,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.end,
      spacing: 8,
      runSpacing: 8,
      children: [
        _DesktopActionButton(
          onPressed: onEditar,
          icon: const Icon(Icons.edit_outlined),
          label: const Text('Editar'),
        ),
        _DesktopActionButton(
          onPressed: onConcluir,
          icon: Icon(
            concluida ? Icons.check_circle : Icons.check_circle_outline,
          ),
          label: Text(concluida ? 'Concluída' : 'Concluir'),
          foregroundColor: ManutencoesUiColors.statusConcluida,
        ),
        _DesktopActionButton(
          onPressed: onExcluir,
          icon: const Icon(Icons.delete_outline),
          label: const Text('Excluir'),
          foregroundColor: ManutencoesUiColors.statusVencida,
        ),
      ],
    );
  }
}

class _CompactActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget icon;
  final Widget label;
  final Color? foregroundColor;

  const _CompactActionButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: label,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 8,
        ),
        foregroundColor: foregroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}

class _DesktopActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget icon;
  final Widget label;
  final Color? foregroundColor;

  const _DesktopActionButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: label,
      style: OutlinedButton.styleFrom(
        foregroundColor: foregroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
