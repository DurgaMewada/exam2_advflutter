import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Helper/db_helper.dart';
import '../Modal/contact_modal.dart';
import '../Service/contact_service.dart';


class ContactProvider extends ChangeNotifier {
  List contactList = [];
  List<ContactModal> contactCloudList = [];
  var txtname = TextEditingController();
  var txtphone = TextEditingController();
  var txtemail = TextEditingController();


  Future<void> initDatabase() async {
    await DatabaseHelper.databaseHelper.initDatabase();
  }

  // Sync Firestore data to local SQLite with update or insert logic
  Future<void> syncCloudToLocal() async {
    try {
      // Fetch all notes from Firestore
      final snapshot = await ContactServices.contactServices.readFromFireStore().first;
      final cloudNotes = snapshot.docs.map((doc) {
        final data = doc.data();
        return ContactModal(
          id: int.parse(data['id'].toString()),
          name: data['name'],
          phone: data['phone'],
          email: data['email'],
        );
      }).toList();

      // Sync each note from Firestore to local SQLite
      for (var contact in cloudNotes) {
        bool exists = await DatabaseHelper.databaseHelper.contactExists(contact.id!);
        if (exists) {
          // Update the note if it exists
          await DatabaseHelper.databaseHelper.updateNotes(
            contact.id!,
              contact.name,
              contact.phone,
              contact.email
          );
        } else {
          // Insert the note if it doesn't exist
          await DatabaseHelper.databaseHelper.addToDatabase(
              contact.name,
              contact.phone,
              contact.email
          );
        }
      }

      // Reload local notes list
      await readDataFromDatabase();
      notifyListeners();
    } catch (e) {
      debugPrint("Error syncing data: $e");
    }
  }

  Future<void> addNotesDatabase(
      String name, String phone, String email) async {
    await DatabaseHelper.databaseHelper.addToDatabase(
     name,phone,email
    );
    toMap(
      ContactModal(
        name: name,
        phone: phone,
        email: email

      ),
    );

    readDataFromDatabase();
    clearAllVar();
    notifyListeners();
  }

  Future<void> addNoteFireStore(ContactModal data) async {
    await ContactServices.contactServices.addToFireStore(
      data.id!,
      data.name,
      data.phone,
      data.email
    );
  }

  Future<void> updateDataFromFirestore(ContactModal data) async {
    await ContactServices.contactServices.updateInFireStore(
      data.id!,
      data.name,
      data.phone,
      data.email,
    );
  }

  Future<void> deleteDataFromFireStore(int id) async {
    await ContactServices.contactServices.deleteFromFireStore(id);
  }

  void clearAllVar() {
    txtname.clear();
    txtphone.clear();
    txtemail.clear();
    notifyListeners();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> readDataFromFireStore() {
    return ContactServices.contactServices.readFromFireStore();
  }

  Future<List<Map<String, Object?>>> readDataFromDatabase() async {
    return contactList = await DatabaseHelper.databaseHelper.readAllNotes();
  }

  Future<void> updateNoteInDatabase(int id, String name, String phone,
      String email) async {
    await DatabaseHelper.databaseHelper.updateNotes(
      id,
     name,
      phone,
      email
    );
    clearAllVar();
    notifyListeners();
  }

  Future<void> deleteNoteInDatabase(int id) async {
    await DatabaseHelper.databaseHelper.deleteNote(id);
    notifyListeners();
  }

  NotesProvider() {
    initDatabase();
  }
}
