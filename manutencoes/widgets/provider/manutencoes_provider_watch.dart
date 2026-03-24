part of '../../manutencoes_provider.dart';

extension ManutencoesProviderWatch on ManutencoesProvider {
  Future<void> watchCondominio(String condominioId) async {
    final cId = condominioId.trim();
    if (cId.isEmpty) {
      throw ArgumentError('condominioId não pode ser vazio');
    }

    _condominioAtualId = cId;

    await _sub?.cancel();
    _sub = null;

    _clearError();
    _setLoading(true);

    try {
      final q = _queryManutencoes(cId);

      _sub = q.snapshots().listen(
        (snap) {
          _applySnapshot(snap);
          _loading = false;
          _notify();
        },
        onError: (e) {
          _erro = e.toString();
          _loading = false;
          _notify();
        },
      );
    } catch (e) {
      _setError(e);
      _loading = false;
      _notify();
    }
  }

  Future<void> carregar() async {
    final id = _condominioAtualId;
    if (id == null) return;
    await watchCondominio(id);
  }

  Future<void> refresh() async {
    final id = _condominioAtualId;
    if (id == null) return;

    _clearError();
    _setLoading(true);

    try {
      final snap = await _queryManutencoes(id).get();
      _applySnapshot(snap);
    } catch (e) {
      _setError(e);
    } finally {
      _loading = false;
      _notify();
    }
  }

  Future<void> limpar() async {
    await _sub?.cancel();
    _sub = null;

    _condominioAtualId = null;
    _lista.clear();
    _loading = false;
    _erro = null;
    _notify();
  }
}
