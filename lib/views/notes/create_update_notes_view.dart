import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:worknotes/services/auth/auth_services.dart';
import 'package:worknotes/utilities/dialog/cannot_share_empty_note.dart';
import 'package:worknotes/utilities/generics/get_argument.dart';
import 'package:worknotes/services/cloud/firebase_cloud_storeage.dart';
import 'package:worknotes/services/cloud/clout_store_note.dart';
import 'package:worknotes/services/cloud/cloud_storage_exception.dart';

class CreateUpdateNotesView extends StatefulWidget {
  const CreateUpdateNotesView({super.key});

  @override
  State<CreateUpdateNotesView> createState() => _CreateUpdateNotesViewState();
}

class _CreateUpdateNotesViewState extends State<CreateUpdateNotesView> {
  CloudNote? _note;
  late final FirebaseCloudStroage _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesService = FirebaseCloudStroage();
    _textController = TextEditingController();
    super.initState();
  }

  void _textConstrollerListner() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _notesService.updateNote(text: text, documentId: note.doumentId);
  }

  void _setupTextControllerListner() {
    _textController.removeListener(_textConstrollerListner);
    _textController.addListener(_textConstrollerListner);
  }

  Future<CloudNote> createOrGetExisitingNote(BuildContext context) async {
    debugPrint("I am in the createnewNote");
    final widgetNote = context.getArguments<CloudNote>();
    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.text;
      return widgetNote;
    }
    final existingnote = _note;
    if (existingnote != null) {
      return existingnote;
    }
    final currentUser = AuthServices.firebase().currentUser!;
    final userId = currentUser.id;
    final newNote = await _notesService.createNewNote(ownerUserId: userId);
    _note = newNote;
    return newNote;
  }

  Future<void> _deleteEmptyNote() async {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      await _notesService.deleteNote(documentId: note.doumentId);
    }
  }

  Future<void> _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (text.isNotEmpty && note != null) {
      await _notesService.updateNote(
        text: text,
        documentId: note.doumentId,
      );
    }
  }

  @override
  void dispose() {
    _deleteEmptyNote();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Notes"),
          actions: [
            IconButton(
                onPressed: () async {
                  final text = _textController.text;
                  if (_note == null || text.isEmpty) {
                    await showCannotShareEmptyNoteDialog(context);
                  } else {
                    Share.share(text);
                  }
                },
                icon: const Icon(Icons.share))
          ],
        ),
        body: FutureBuilder(
          future: createOrGetExisitingNote(context),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                _setupTextControllerListner();
                return TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Start Tyoing Your Note....',
                  ),
                );
              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
}
