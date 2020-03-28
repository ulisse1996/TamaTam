
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/tama.dart';

final Firestore _firestore = Firestore.instance;

const String _collName = 'tama';

Future<Tama> findTamaById(String tamaId) async {
  final QuerySnapshot val = await _firestore.collection(_collName)
    .where('tamaId', isEqualTo: tamaId)
    .getDocuments();
  if (val.documents.isEmpty) {
    print("Can't find tama");
    return null;
  } else {
    return Tama.fromJson(val.documents[0].data);
  }
}

Future<void> createTama(Tama tama) async {
  await _firestore.collection(_collName)
    .add(tama.toJson());
}

Future<void> saveTama(Tama tama) async {
  final QuerySnapshot val = await _firestore.collection(_collName)
    .where('tamaId', isEqualTo: tama.tamaId)
    .getDocuments();
  final String docId = val.documents[0].documentID;
  await _firestore.collection(_collName)
    .document(docId)
    .setData(tama.toJson());
}