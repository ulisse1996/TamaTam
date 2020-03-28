
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/tama.dart';

final Firestore _firestore = Firestore.instance;

class TamaRepository {
  static final _collName = "tama";

  static Future<Tama> findTamaById(String tamaId) async {
    QuerySnapshot val = await _firestore.collection(_collName)
      .where("tamaId", isEqualTo: tamaId)
      .getDocuments();
    if (val.documents.length == 0) {
      print("Can't find tama");
      return null;
    } else {
      return Tama.fromJson(val.documents[0].data);
    }
  }

  static Future<void> createTama(Tama tama) async {
    await _firestore.collection(_collName)
      .add(tama.toJson());
  }

  static Future<void> saveTama(Tama tama) async {
    QuerySnapshot val = await _firestore.collection(_collName)
      .where("tamaId", isEqualTo: tama.tamaId)
      .getDocuments();
    String docId = val.documents[0].documentID;
    await _firestore.collection(_collName)
      .document(docId)
      .setData(tama.toJson());
  }
}