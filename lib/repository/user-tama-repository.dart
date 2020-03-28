import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user-info.dart';

final Firestore _firestore = Firestore.instance;


const String _repoName = 'userTama';

Future<UserInfo> findUser(String userId) async {
  final QuerySnapshot val = await _firestore
      .collection(_repoName)
      .where('userId', isEqualTo: userId)
      .getDocuments();
  if (val.documents.isEmpty) {
    return Future<UserInfo>.value(null);
  } else {
    return UserInfo.fromJson(val.documents[0].data);
  }
}

Future<void> saveUser(UserInfo userInfo) async {
  final QuerySnapshot val = await _firestore
      .collection(_repoName)
      .where('userId', isEqualTo: userInfo.userId)
      .getDocuments();
  final String docId = val.documents[0].documentID;
  _firestore.collection(_repoName)
    .document(docId)
    .setData(userInfo.toJson());
}

Future<void> createUser(UserInfo userInfo) async {
  final DocumentReference ref = await _firestore.collection(_repoName)
    .add(userInfo.toJson());
  final String docId = ref.documentID;
  print('Add new tama with id $docId');
}
