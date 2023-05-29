import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:worknotes/services/cloud/cloud_storage_exception.dart';
import 'package:worknotes/services/cloud/cloud_store_constant.dart';
import 'package:worknotes/services/cloud/clout_store_note.dart';

class FirebaseCloudStroage {
  final notes = FirebaseFirestore.instance.collection('notes');

  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final document = await notes.add({
      ownerIdFieldName: ownerUserId,
      textFieldName: '',
    });
    final fetchedNote = await document.get();
    return CloudNote(
        doumentId: fetchedNote.id, ownerUserId: ownerUserId, text: '');
  }

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> updateNote({
    required String text,
    required String documentId,
  }) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (_) {
      throw CouldNotUpdateNoteException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
      notes.snapshots().map(
            (event) =>
                event.docs.map((doc) => CloudNote.fromSnapshot(doc)).where(
                      (note) => note.ownerUserId == ownerUserId,
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
              (value) => value.docs.map((doc) => CloudNote.fromSnapshot(doc)));
    } catch (e) {
      throw CouldNotGetAllNoteException();
    }
  }

  static final FirebaseCloudStroage _shared =
      FirebaseCloudStroage._sharedInstance();
  FirebaseCloudStroage._sharedInstance();
  factory FirebaseCloudStroage() => _shared;
}
