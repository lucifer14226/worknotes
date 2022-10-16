import 'package:flutter/cupertino.dart';
import 'package:worknotes/utilities/dialog/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Log Out',
    content: 'Are you sure you want to Logout',
    optionsBuilder: () => {'Cancel': false, 'Log Out': true},
  ).then((value) => value ?? false);
}
