import '../../manutencoes_model.dart';

String? manutencaoFormNullIfEmpty(String? v) {
  final s = (v ?? '').trim();
  return s.isEmpty ? null : s;
}

String manutencaoFormNorm(String input) {
  final s = input.trim().toLowerCase();

  const mapa = {
    'á': 'a',
    'à': 'a',
    'â': 'a',
    'ã': 'a',
    'ä': 'a',
    'é': 'e',
    'è': 'e',
    'ê': 'e',
    'ë': 'e',
    'í': 'i',
    'ì': 'i',
    'î': 'i',
    'ï': 'i',
    'ó': 'o',
    'ò': 'o',
    'ô': 'o',
    'õ': 'o',
    'ö': 'o',
    'ú': 'u',
    'ù': 'u',
    'û': 'u',
    'ü': 'u',
    'ç': 'c',
  };

  final buffer = StringBuffer();
  for (final rune in s.runes) {
    final ch = String.fromCharCode(rune);
    buffer.write(mapa[ch] ?? ch);
  }

  return buffer.toString().replaceAll(RegExp(r'\s+'), ' ').trim();
}

String manutencaoFormFormatDate(DateTime? d) {
  if (d == null) return 'Selecionar data';
  final dd = d.day.toString().padLeft(2, '0');
  final mm = d.month.toString().padLeft(2, '0');
  return '$dd/$mm/${d.year}';
}

DateTime manutencaoFormAjustarDataParaDatePicker(DateTime? value) {
  final min = DateTime(2020, 1, 1);
  final max = DateTime(2100, 12, 31);

  final base = value == null
      ? DateTime.now()
      : DateTime(value.year, value.month, value.day);

  if (base.isBefore(min)) return min;
  if (base.isAfter(max)) return max;
  return base;
}

String manutencaoFormPeriodicidadeLabel({
  required PeriodicidadeTipo periodicidadeTipo,
  required int intervaloValor,
  required IntervaloUnidade intervaloUnidade,
}) {
  return intervalToLegacyLabel(
    periodicidadeTipo,
    periodicidadeTipo == PeriodicidadeTipo.diaria ? 1 : intervaloValor,
    periodicidadeTipo == PeriodicidadeTipo.diaria
        ? IntervaloUnidade.dias
        : intervaloUnidade,
    '',
  );
}
