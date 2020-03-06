import 'package:flutter/material.dart';

import '../model/episode.dart';
import 'img_or_placeholder.dart';
import 'podcast_provider.dart';

class EpisodePage extends StatelessWidget {
  final int id;
  EpisodePage({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Bloc bloc = BlocProvider.of(context);
    bloc.fetchEpisode(id);
    return StreamBuilder(
      stream: bloc.outEpisodes,
      builder: (BuildContext context, AsyncSnapshot<List<Episode>> snapshot) {
        if (snapshot.hasData &&
            snapshot.data.length > 0 &&
            !snapshot.hasError) {
          return _someThing2Show(snapshot.data);
        } else if (snapshot.data?.length == 0) {
          return Center(
            child: Text('No Episodes found'),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _someThing2Show(List<Episode> data) {
    Episode e = data.firstWhere((e) => e.id == id);
    return ListTile(
      leading: ImgOrPlaceholder(path: e.imageOffline),
      title: Text(e.title),
      subtitle: Text(e.pubDate.toIso8601String()),
    );
  }
}
