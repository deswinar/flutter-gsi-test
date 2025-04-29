import 'package:flutter/material.dart';

extension ContextX on BuildContext {
  Size get screenSize => MediaQuery.of(this).size;
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
}
