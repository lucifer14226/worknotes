import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:worknotes/services/crud/cloud/cloud_store_constant.dart';
import 'package:flutter/cupertino.dart';

@immutable
class CloudNote {
  final String doumentId;
  final String owenerUserId;
  final String text;

  const CloudNote({
    required this.doumentId,
    required this.owenerUserId,
    required this.text,
  });

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : doumentId = snapshot.id,
        owenerUserId = snapshot.data()[ownerIdFieldName],
        text = snapshot.data()[textFieldName] as String;
}
