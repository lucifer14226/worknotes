import 'package:flutter/material.dart';
import 'package:worknotes/utilities/dialog/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) async {
  return showGenericDialog(
    context: context,
    title: 'Sharing',
    content: 'You cannot Share empty note',
    optionsBuilder: () => {'OK': null},
  );
}
