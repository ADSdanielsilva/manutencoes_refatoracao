part of '../../manutencoes_model.dart';

DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

DateTime addDays(DateTime base, int days) =>
    dateOnly(base).add(Duration(days: days));

DateTime addMonthsClamped(DateTime base, int months) {
  final b = dateOnly(base);

  final total = (b.year * 12 + (b.month - 1)) + months;
  final newYear = total ~/ 12;
  final newMonth = (total % 12) + 1;

  final lastDayOfTargetMonth = DateTime(newYear, newMonth + 1, 0).day;
  final newDay = b.day <= lastDayOfTargetMonth ? b.day : lastDayOfTargetMonth;

  return DateTime(newYear, newMonth, newDay);
}

DateTime addYearsClamped(DateTime base, int years) {
  final b = dateOnly(base);
  final targetYear = b.year + years;
  final lastDay = DateTime(targetYear, b.month + 1, 0).day;
  final newDay = b.day <= lastDay ? b.day : lastDay;

  return DateTime(targetYear, b.month, newDay);
}

({int valor, IntervaloUnidade unidade}) legacyPeriodicidadeToInterval(
  String legacy,
) {
  final p = legacy.trim().toLowerCase();

  if (p == 'diaria' || p == 'diária') {
    return (valor: 1, unidade: IntervaloUnidade.dias);
  }
  if (p == 'mensal') return (valor: 1, unidade: IntervaloUnidade.meses);
  if (p == 'bimestral') return (valor: 2, unidade: IntervaloUnidade.meses);
  if (p == 'trimestral') return (valor: 3, unidade: IntervaloUnidade.meses);
  if (p == 'semestral') return (valor: 6, unidade: IntervaloUnidade.meses);
  if (p == 'anual') return (valor: 1, unidade: IntervaloUnidade.anos);

  return (valor: 1, unidade: IntervaloUnidade.meses);
}

String intervalToLegacyLabel(
  PeriodicidadeTipo tipo,
  int valor,
  IntervaloUnidade unidade,
  String legacyPrefer,
) {
  final lp = legacyPrefer.trim();
  if (lp.isNotEmpty) return lp;

  if (tipo == PeriodicidadeTipo.diaria) return 'Diária';

  if (unidade == IntervaloUnidade.meses && valor == 1) return 'Mensal';
  if (unidade == IntervaloUnidade.meses && valor == 2) return 'Bimestral';
  if (unidade == IntervaloUnidade.meses && valor == 3) return 'Trimestral';
  if (unidade == IntervaloUnidade.meses && valor == 6) return 'Semestral';
  if (unidade == IntervaloUnidade.anos && valor == 1) return 'Anual';

  final u = unidade == IntervaloUnidade.dias
      ? (valor == 1 ? 'dia' : 'dias')
      : unidade == IntervaloUnidade.meses
          ? (valor == 1 ? 'mês' : 'meses')
          : (valor == 1 ? 'ano' : 'anos');

  return 'A cada $valor $u';
}

String normalizarStatus(String raw) {
  final s = raw.trim().toLowerCase();

  if (s.contains('andamento')) return 'Em andamento';
  if (s.contains('conclu')) return 'Concluída';
  return 'Pendente';
}

DateTime? parseManutencaoDate(dynamic v) {
  if (v == null) return null;
  if (v is DateTime) return v;
  if (v is Timestamp) return v.toDate();

  if (v is String) {
    final raw = v.trim();
    if (raw.isEmpty) return null;

    final iso = DateTime.tryParse(raw);
    if (iso != null) return iso;

    final br = RegExp(r'^(\d{2})/(\d{2})/(\d{4})$').firstMatch(raw);
    if (br != null) {
      final dia = int.tryParse(br.group(1)!);
      final mes = int.tryParse(br.group(2)!);
      final ano = int.tryParse(br.group(3)!);
      if (dia != null && mes != null && ano != null) {
        return DateTime(ano, mes, dia);
      }
    }

    return null;
  }

  if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
  if (v is num) return DateTime.fromMillisecondsSinceEpoch(v.toInt());
  return null;
}
