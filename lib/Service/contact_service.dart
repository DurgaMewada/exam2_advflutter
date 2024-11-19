import 'package:cloud_firestore/cloud_firestore.dart';

class ContactServices {
  ContactServices._();

  static ContactServices contactServices = ContactServices._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addToFireStore(int id, String name, String phone,
      String email) async {
    await _firestore.collection("contact").doc(id.toString()).set({
      'id': id,
      'name':name,
      'phone':phone,
      'email':email
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> readFromFireStore() {
    return _firestore.collection("contact").snapshots();
  }

  Future<void> deleteFromFireStore(int id) async {
    await _firestore.collection("contact").doc(id.toString()).delete();
  }

  Future<void> updateInFireStore(int id, String name, String phone,
      String email) async {
    await _firestore.collection("contact").doc(id.toString()).update({
      'id': id,
      'name':name,
      'phone':phone,
      'email':email,
    });
  }
}
