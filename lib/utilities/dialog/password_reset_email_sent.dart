import 'package:flutter/cupertino.dart';
import 'package:worknotes/utilities/dialog/generic_dialog.dart';

Future<void> showPaasswordResetSendDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Password Reset',
    content: 'We have sent you password reset email ',
    optionsBuilder: () => {
      'Ok': null,
    },
  );
}
