import 'package:flutter/material.dart';
import 'package:podcatcher/src/bloc/bloc.dart';
import 'package:podcatcher/src/widgets/delete_podcast_dialog.dart';
import 'package:podcatcher/src/widgets/podcast_provider.dart';

import 'episodes_list.dart';

class PodcastPage extends StatelessWidget {
  final Podcast podcast;
  PodcastPage({Key key, this.podcast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Bloc pbloc = BlocProvider.of(context);
    pbloc.fetchPodcasts();

    return Scaffold(
      appBar: AppBar(
        title: Text(podcast.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            // iconSize: 48.0,
            onPressed: () {
              _deleteDialog(context, podcast);
            },
          ),
        ],
      ),
      body: EpisodesList(podcastId: podcast.id),
    );
  }

  Future<void> _deleteDialog(BuildContext context, Podcast podcast) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return DeletePodcastDialog(podcast: podcast);
      },
    );
  }
}
