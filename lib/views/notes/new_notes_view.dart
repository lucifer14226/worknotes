import 'package:flutter/material.dart';
import 'package:worknotes/services/auth/auth_services.dart';
import 'package:worknotes/services/crud/notes_services.dart';

class NewNotesView extends StatefulWidget {
  const NewNotesView({super.key});

  @override
  State<NewNotesView> createState() => _NewNotesViewState();
}

class _NewNotesViewState extends State<NewNotesView> {
  DataBaseNotes? _note;
  late final NotesServices _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesService = NotesServices();
    _textController = TextEditingController();
    super.initState();
  }

  Future<DataBaseNotes> createNewNote() async {
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthServices.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _notesService.getUser(email: email);
    return await _notesService.createNotes(owner: owner);
  }

  void _deleteNoteIfEmptyNote() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(
        notes: note,
        text: text,
      );
    }
  }

  void _textControllerListner() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _notesService.updateNote(
      notes: note,
      text: text,
    );
  }

  void _setupTextControllerListner() {
    _textController.removeListener(_textControllerListner);
    _textController.addListener(_textControllerListner);
  }

  @override
  void dispose() {
    _deleteNoteIfEmptyNote();
    _saveNoteIfNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("New Notes"),
        ),
        body: FutureBuilder(
          future: createNewNote(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                _note = snapshot.data as DataBaseNotes?;
                _setupTextControllerListner();
                return TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: "Start Typing Your Notes.....",
                  ),
                );
              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
}
