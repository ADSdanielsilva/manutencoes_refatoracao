import 'dart:developer' as developer;

import 'package:cloud_functions/cloud_functions.dart';

import 'package:app_sindico/shared/models/condominio.dart';

class ImportacaoManutencoesResultado {
  final int importadas;
  final int ignoradas;

  const ImportacaoManutencoesResultado({
    required this.importadas,
    required this.ignoradas,
  });
}

class ManutencoesImportService {
  final FirebaseFunctions _functions;

  ManutencoesImportService({
    FirebaseFunctions? functions,
  }) : _functions = functions ??
            FirebaseFunctions.instanceFor(region: 'southamerica-east1');

  Future<ImportacaoManutencoesResultado> importarDoCondominio({
    required Condominio condominio,
  }) async {
    final condominioId = condominio.id.trim();

    if (condominioId.isEmpty) {
      throw Exception('Condomínio inválido: id vazio.');
    }

    developer.log(
      '[IMPORTACAO] condominioId=$condominioId | condominioNome="${condominio.nome}"',
      name: 'ManutencoesImportService',
    );

    try {
      final callable = _functions.httpsCallable(
        'importarManutencoesPlanilha',
      );

      final response = await callable.call(<String, dynamic>{
        'condominioId': condominioId,
      });

      final data = Map<String, dynamic>.from(response.data as Map);

      final importadas = (data['importadas'] as num?)?.toInt() ?? 0;
      final ignoradas = (data['ignoradas'] as num?)?.toInt() ?? 0;

      return ImportacaoManutencoesResultado(
        importadas: importadas,
        ignoradas: ignoradas,
      );
    } on FirebaseFunctionsException catch (e) {
      final message = e.message?.trim();
      throw Exception(
        message == null || message.isEmpty
            ? 'Erro ao importar planilha.'
            : message,
      );
    } catch (e) {
      throw Exception('Erro ao importar planilha: $e');
    }
  }
}
