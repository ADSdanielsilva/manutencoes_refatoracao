part of '../../manutencoes_model.dart';

enum PeriodicidadeTipo { diaria, periodica }

enum IntervaloUnidade { dias, meses, anos }

String periodicidadeTipoToStr(PeriodicidadeTipo v) =>
    v == PeriodicidadeTipo.diaria ? 'DIARIA' : 'PERIODICA';

PeriodicidadeTipo periodicidadeTipoFromStr(String raw) {
  final s = raw.trim().toUpperCase();
  if (s == 'DIARIA' || s == 'DIÁRIA') return PeriodicidadeTipo.diaria;
  return PeriodicidadeTipo.periodica;
}

String intervaloUnidadeToStr(IntervaloUnidade v) {
  switch (v) {
    case IntervaloUnidade.dias:
      return 'DIAS';
    case IntervaloUnidade.meses:
      return 'MESES';
    case IntervaloUnidade.anos:
      return 'ANOS';
  }
}

IntervaloUnidade intervaloUnidadeFromStr(String raw) {
  final s = raw.trim().toUpperCase();
  if (s == 'DIA' || s == 'DIAS') return IntervaloUnidade.dias;
  if (s == 'MES' || s == 'MÊS' || s == 'MESES') return IntervaloUnidade.meses;
  if (s == 'ANO' || s == 'ANOS') return IntervaloUnidade.anos;
  return IntervaloUnidade.meses;
}
