import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:worknotes/services/crud/cloud/cloud_storage_exception.dart';
import 'package:worknotes/services/crud/cloud/cloud_store_constant.dart';
import 'package:worknotes/services/crud/cloud/clout_store_note.dart';

class FirebaseCloudStroage {
  final notes = FirebaseFirestore.instance.collection('notes');

  void createNewNote({required String ownerUserId}) async {
    await notes.add({
      ownerIdFieldName: ownerUserId,
      textFieldName: '',
    });

    Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
        notes.snapshots().map(
              (event) =>
                  event.docs.map((doc) => CloudNote.fromSnapshot(doc)).where(
                        (note) => note.owenerUserId == ownerUserId,
                      ),
            );

    Future<Iterable<CloudNote>> getNote({required String ownerUserId}) async {
      try {
        return await notes
            .where(
              ownerIdFieldName,
              isEqualTo: ownerUserId,
            )
            .get()
            .then(
              (value) => value.docs.map(
                (doc) {
                  return CloudNote(
                    doumentId: doc.id,
                    owenerUserId: doc.data()[ownerIdFieldName],
                    text: doc.data()[textFieldName] as String,
                  );
                },
              ),
            );
      } catch (e) {
        throw CouldNotGetAllNoteException();
      }
    }
  }

  static final FirebaseCloudStroage _shared =
      FirebaseCloudStroage._sharedInstance();
  FirebaseCloudStroage._sharedInstance();
  factory FirebaseCloudStroage() => _shared;
}
