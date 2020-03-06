import 'package:flutter/material.dart';
import 'package:podcatcher/src/bloc/bloc.dart';

export 'package:podcatcher/src/bloc/bloc.dart';

class BlocProvider extends InheritedWidget {
  BlocProvider({
    Key key,
    @required Widget child,
    this.bloc,
  }) : super(key: key, child: child);

  final Bloc bloc;

  static Bloc of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<BlocProvider>();
    return widget.bloc;
  }

  @override
  bool updateShouldNotify(BlocProvider oldWidget) =>
      bloc != oldWidget.bloc;
}
