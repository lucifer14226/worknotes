import 'package:flutter/cupertino.dart';
import 'package:worknotes/utilities/dialog/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) async {
  return showGenericDialog(
    context: context,
    title: 'An error Occurred',
    content: text,
    optionsBuilder: () => {
      'Ok': null,
    },
  );
}
