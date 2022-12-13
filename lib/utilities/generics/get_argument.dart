import 'package:flutter/material.dart' show BuildContext, ModalRoute;

extension GetArguments on BuildContext {
  T? getArguments<T>() {
    final modalRoutes = ModalRoute.of(this);
    if (modalRoutes != null) {
      final args = modalRoutes.settings.arguments;
      if (args != null && args is T) {
        return args as T;
      }
    }
    return null;
  }
}
