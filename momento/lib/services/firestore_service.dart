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

  Future<Null> createDocumentById(
      String collection, String documentId, Map<String, dynamic> jsonData) async {
    await _firestore.collection(collection).document(documentId).setData(jsonData);
  }

  Future<String> createDocument({String collection, Map<String, dynamic> jsonData}) async {
    final dr = await _firestore.collection(collection).add(jsonData);
    return dr.documentID;
  }

  Future<Null> updateDocumentByField({
    String collection,
    String documentId,
    String field,
    dynamic newData,
  }) async {
    await _firestore.collection(collection).document(documentId).updateData({
      field: newData,
    });
  }

  Future<Null> updateDocument({
    String collection,
    String documentId,
    Map<String, dynamic> newData,
  }) async {
    await _firestore.collection(collection).document(documentId).setData(newData);
  }
}
