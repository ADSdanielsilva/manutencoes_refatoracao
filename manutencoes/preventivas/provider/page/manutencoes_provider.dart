import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:app_sindico/features/manutencoes/preventivas/model/page/manutencoes_model.dart';

part '../manutencoes_provider_helpers.dart';
part '../manutencoes_provider_watch.dart';
part '../manutencoes_provider_queries.dart';
part '../manutencoes_provider_crud.dart';
part '../manutencoes_provider_series.dart';

class RelatorioPendencias {
  final List<Manutencao> vencidas;
  final List<Manutencao> aVencer;

  RelatorioPendencias({
    required this.vencidas,
    required this.aVencer,
  });

  int get total => vencidas.length + aVencer.length;
}

enum EscopoAtualizacaoSerie {
  onlyThis,
  allInSeries,
  thisAndFuture,
}

class ManutencoesProvider extends ChangeNotifier {
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  ManutencoesProvider({
    FirebaseFirestore? db,
    FirebaseAuth? auth,
  })  : _db = db ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  bool get useRealtime => true;

  final List<Manutencao> _lista = <Manutencao>[];
  List<Manutencao> get lista => List.unmodifiable(_lista);

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _sub;
  String? _condominioAtualId;

  bool _loading = false;
  bool get loading => _loading;

  String? _erro;
  String? get erro => _erro;

  String get _uid {
    final u = _auth.currentUser;
    if (u == null) {
      throw Exception('Usuário não autenticado');
    }
    return u.uid;
  }

  CollectionReference<Map<String, dynamic>> _colManutencoes(
    String condominioId,
  ) {
    return _db
        .collection('condominios')
        .doc(condominioId)
        .collection('manutencoes');
  }

  Query<Map<String, dynamic>> _queryManutencoes(String condominioId) {
    return _colManutencoes(condominioId);
  }

  void _notify() {
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
