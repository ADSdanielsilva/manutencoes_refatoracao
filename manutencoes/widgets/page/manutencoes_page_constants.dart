import 'package:flutter/material.dart';

enum ManutencaoTabMain {
  diaria,
  periodica,
  todas,
}

class ManutencoesBreakpoints {
  static const double mobile = 760;
  static const double desktop = 1100;
}

class ManutencoesUiColors {
  static const Color pageBackground = Color(0xFFF5F7FB);

  static const Color cardBackground = Colors.white;
  static const Color border = Color(0xFFE4E8F0);
  static const Color textMuted = Color(0xFF6B7280);

  static const Color primary = Color(0xFF4F46E5);

  static const Color diaria = Color(0xFF2563EB);
  static const Color periodica = Color(0xFF7C3AED);
  static const Color vencida = Color(0xFFEF4444);
  static const Color prox30 = Color(0xFFF59E0B);
  static const Color pendente = Color(0xFF0EA5E9);

  static const Color statusConcluida = Color(0xFF22C55E);
  static const Color statusVencida = Color(0xFFEF4444);
  static const Color statusProxima = Color(0xFFF59E0B);
  static const Color statusPlanejada = Color(0xFF3B82F6);
  static const Color statusNeutra = Color(0xFF9CA3AF);
}
