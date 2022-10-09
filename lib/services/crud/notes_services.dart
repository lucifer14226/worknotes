import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'package:worknotes/services/crud/crud_crudexception.dart';

class NotesServices {
  Database? _db;

  List<DataBaseNotes> _notes = [];

  final _notesStreamController =
      StreamController<List<DataBaseNotes>>.broadcast();

  Stream<List<DataBaseNotes>> get allNotes => _notesStreamController.stream;

  Future<DataBaseUser> getOrCreateUser({required String email}) async {
    try {
      final user = getUser(email: email);
      return user;
    } on CouldNotFindUser {
      final createdUser = await createUser(email: email);
      return createdUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _cacheNotes() async {
    final allNotes = await getAllNotes();
    _notes = allNotes.toList();
    _notesStreamController.add(_notes);
  }

  Future<DataBaseNotes> updateNote({
    required DataBaseNotes notes,
    required String text,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    //make sure notes exists
    await getNote(id: notes.id);

    //update the database
    final updateCount = await db
        .update(notesTable, {textColumn: text, isSyncedWithCloudColumn: 0});

    if (updateCount == 0) {
      throw CouldNotUpdateNote();
    } else {
      final updatedNotes = await getNote(id: notes.id);
      _notes.removeWhere((note) => note.id == updatedNotes.id);
      _notes.add(updatedNotes);
      _notesStreamController.add(_notes);
      return updatedNotes;
    }
  }

  Future<Iterable<DataBaseNotes>> getAllNotes() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final notes = await db.query(notesTable);

    return notes.map((notesRow) => DataBaseNotes.fromRow(notesRow));
  }

  Future<DataBaseNotes> getNote({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final notes = await db.query(
      notesTable,
      limit: 1,
      where: 'id=?',
      whereArgs: [id],
    );
    if (notes.isEmpty) {
      throw CouldNotFindNote();
    } else {
      final note = DataBaseNotes.fromRow(notes.first);
      _notes.removeWhere((note) => note.id == id);
      _notesStreamController.add(_notes);
      _notesStreamController.add(_notes);
      return note;
    }
  }

  Future<int> deleteAllNotes() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final numberofDeletion = await db.delete(notesTable);

    _notes = [];
    _notesStreamController.add(_notes);
    return numberofDeletion;
  }

  Future<void> deleteNote({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deleteCount = await db.delete(
      notesTable,
      where: 'id=?',
      whereArgs: [id],
    );
    if (deleteCount == 0) {
      throw CouldNotDeleteNote();
    } else {
      _notes.removeWhere((note) => note.id == id);
      _notesStreamController.add(_notes);
    }
  }

  Future<DataBaseNotes> createNotes({required DataBaseUser owner}) async {
    final db = _getDatabaseOrThrow();
    final dbUser = getUser(email: owner.email);

    //make sure owner exist in database with corrext id and email
    // ignore: unrelated_type_equality_checks
    if (dbUser != owner) {
      throw CouldNotFindUser();
    }

    const text = "";
    //create the note
    final noteID = await db.insert(
      notesTable,
      {useridColumn: owner.id, textColumn: text, isSyncedWithCloudColumn: 1},
    );
    final notes = DataBaseNotes(
      id: noteID,
      userId: owner.id,
      text: text,
      isSyncedWithcloud: true,
    );
    _notes.add(notes);
    _notesStreamController.add(_notes);

    return notes;
  }

  Future<DataBaseUser> getUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final result = await db.query(
      userTable,
      limit: 1,
      where: 'email=?',
      whereArgs: [email.toLowerCase()],
    );
    if (result.isEmpty) {
      throw CouldNotFindUser();
    } else {
      return DataBaseUser.fromRow(result.first);
    }
  }

  Future<DataBaseUser> createUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final result = await db.query(
      userTable,
      limit: 1,
      where: 'email=?',
      whereArgs: [email.toLowerCase()],
    );
    if (result.isNotEmpty) {
      throw UserAlreadyExistException();
    }

    final userId = await db.insert(
      userTable,
      {emailColum: email.toLowerCase()},
    );

    return DataBaseUser(id: userId, email: email);
  }

  Future<void> deleteUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deleteCount = await db.delete(
      userTable,
      where: 'email=?',
      whereArgs: [email.toLowerCase()],
    );
    if (deleteCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DataBaseIsNotOpenException();
    } else {
      return db;
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DataBaseIsNotOpenException();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DataBaseAlreadyOpenException {
      //empty
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DataBaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbpath = join(docsPath.path, dbName);
      final db = await openDatabase(dbpath);
      _db = db;

      await db.execute(createUserTable);
      await _cacheNotes();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentDirectory();
    }
  }
}

@immutable
class DataBaseUser {
  final int id;
  final String email;
  const DataBaseUser({
    required this.id,
    required this.email,
  });

  DataBaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColum] as String;

  @override
  String toString() => "Person, Email=$email, ID=$id";

  @override
  bool operator ==(covariant DataBaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DataBaseNotes {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithcloud;

  DataBaseNotes({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedWithcloud,
  });

  DataBaseNotes.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[useridColumn] as int,
        text = map[textColumn] as String,
        isSyncedWithcloud =
            (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;
  @override
  String toString() =>
      "NOTES, ID=$id, USERID=$userId, ISSYNCEDWITHCLOUD=$isSyncedWithcloud ";

  @override
  bool operator ==(covariant DataBaseNotes other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const dbName = "notes.db";
const notesTable = "notes";
const userTable = "user";
const idColumn = "id";
const useridColumn = "user_id";
const textColumn = "text";
const emailColum = "email";
const isSyncedWithCloudColumn = "is_synced_with_cloud";
const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
	          "id"	INTEGER NOT NULL,
	"          email"	TEXT NOT NULL UNIQUE,
	           PRIMARY KEY("id")
          );''';
const createNotesTable = '''CREATE TABLE IF NOT EXISTS "note" (
	        "id"	INTEGER NOT NULL,
	        "user_id"	INTEGER NOT NULL,
	        "text"	TEXT,
          "is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
	        FOREIGN KEY("user_id") REFERENCES "user"("id"),
	        PRIMARY KEY("id" AUTOINCREMENT)
        );''';
