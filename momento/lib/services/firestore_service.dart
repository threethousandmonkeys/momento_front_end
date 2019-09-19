import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  Firestore _firestore = Firestore.instance;

  Future<Map<String, dynamic>> getDocument(String collection, String documentID) async {
    DocumentSnapshot doc = await _firestore.collection(collection).document(documentID).get();
    if (doc != null) {
      return doc.data;
    } else {
      return null;
    }
  }

  Future<Null> createDocument(
      String collection, String documentId, Map<String, dynamic> jsonData) async {
    await _firestore.collection(collection).document(documentId).setData(jsonData);
  }

//  Future<void> uploadMember(String memberId, Family family) async {
//    DocumentSnapshot doc = await _firestore.collection("member").document(memberId).get();
//    Map<String, String> goals =
//        doc.data["goals"] != null ? doc.data["goals"].cast<String, String>() : null;
//    if (goals != null) {
//      goals[title] = goal;
//    } else {
//      goals = Map();
//      goals[title] = goal;
//    }
//    return _firestore
//        .collection("member")
//        .document(memberId)
//        .setData({'goals': goals, 'goalAdded': true}, merge: true);
//  }
//
//  Stream<DocumentSnapshot> myGoalList(String documentId) {
//    return _firestore.collection("users").document(documentId).snapshots();
//  }
//
//  Stream<QuerySnapshot> othersGoalList() {
//    return _firestore.collection("users").where('goalAdded', isEqualTo: true).snapshots();
//  }
//
//  void removeGoal(String title, String documentId) async {
//    DocumentSnapshot doc = await _firestore.collection("users").document(documentId).get();
//    Map<String, String> goals = doc.data["goals"].cast<String, String>();
//    goals.remove(title);
//    if (goals.isNotEmpty) {
//      _firestore.collection("users").document(documentId).updateData({"goals": goals});
//    } else {
//      _firestore
//          .collection("users")
//          .document(documentId)
//          .updateData({'goals': FieldValue.delete(), 'goalAdded': false});
//    }
//  }
}
