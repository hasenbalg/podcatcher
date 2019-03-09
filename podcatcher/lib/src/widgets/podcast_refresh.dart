import 'package:flutter/material.dart';
import 'package:podcatcher/src/widgets/podcast_provider.dart';

class PodcastRefresh extends StatelessWidget {
  final Widget child;

  PodcastRefresh({this.child});

  Widget build(context) {
    PodcastBloc bloc = PodcastBlocProvider.of(context);

    return RefreshIndicator(
      child: child,
      onRefresh: () async {
        // await bloc.clearCache();
        await bloc.updateAll();
        bloc.fetch();
      },
    );
  }
}