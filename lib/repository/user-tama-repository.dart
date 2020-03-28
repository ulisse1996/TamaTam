import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user-info.dart';

final Firestore _firestore = Firestore.instance;

class UserTamaRepository {
  static final _repoName = "userTama";

  static Future<UserInfo> findUser(String userId) async {
    QuerySnapshot val = await _firestore
        .collection(_repoName)
        .where("userId", isEqualTo: userId)
        .getDocuments();
    if (val.documents.isEmpty) {
      return null;
    } else {
      return UserInfo.fromJson(val.documents[0].data);
    }
  }

  static Future<void> saveUser(UserInfo userInfo) async {
    QuerySnapshot val = await _firestore
        .collection(_repoName)
        .where("userId", isEqualTo: userInfo.userId)
        .getDocuments();
    String docId = val.documents[0].documentID;
    _firestore.collection(_repoName)
      .document(docId)
      .setData(userInfo.toJson());
  }

  static Future<void> createUser(UserInfo userInfo) async {
    DocumentReference ref = await _firestore.collection(_repoName)
      .add(userInfo.toJson());
    String docId = ref.documentID;
    print('Add new tama with id $docId');
  }
}
