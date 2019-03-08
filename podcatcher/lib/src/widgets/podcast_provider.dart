import 'package:flutter/material.dart';
import 'package:podcatcher/src/blocs/podcast_bloc.dart';

export 'package:podcatcher/src/blocs/podcast_bloc.dart';

class PodcastBlocProvider extends InheritedWidget {
  PodcastBlocProvider({
    Key key,
    @required Widget child,
    this.bloc,
  }) : super(key: key, child: child);

  final bloc;

  static PodcastBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(PodcastBlocProvider)
            as PodcastBlocProvider)
        .bloc;
  }

  @override
  bool updateShouldNotify(PodcastBlocProvider oldWidget) =>
      bloc != oldWidget.bloc;
}
