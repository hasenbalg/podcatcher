import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:podcatcher/src/widgets/episode_page.dart';
import 'package:podcatcher/src/widgets/img_or_placeholder.dart';
import 'package:podcatcher/src/widgets/podcast_provider.dart';

import '../model/episode.dart';

class EpisodesList extends StatelessWidget {
  final int podcastId;
  final DateFormat dateFormat = DateFormat.yMEd();
  final DateFormat timeFormat = DateFormat.Hm();

  EpisodesList({this.podcastId});
  @override
  Widget build(BuildContext context) {
    Bloc bloc = BlocProvider.of(context);
    bloc.fetchEpisodesOf(podcastId);
    return StreamBuilder(
      stream: bloc.outEpisodes,
      builder: (BuildContext context, AsyncSnapshot<List<Episode>> snapshot) {
        if (snapshot.hasData &&
            snapshot.data.length > 0 &&
            !snapshot.hasError) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              Episode e = snapshot.data[index];
              return buildEpisodeListTile(context, e);
            },
          );
        } 
        // else if (snapshot.hasData && snapshot.data.isEmpty) {
        //   return Center(
        //     child: Text('No Episodes found'),
        //   );
        // }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  ListTile buildEpisodeListTile(BuildContext context, Episode e) {
    return ListTile(
      leading: ImgOrPlaceholder(path: e.imageOffline),
      title: Text(e.title),
      subtitle: Text('${dateFormat.format(e.pubDate)} ${timeFormat.format(e.pubDate)}'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EpisodePage(
              episode: e,
            ),
          ),
        );
      },
    );
  }
}
