import 'package:flutter/material.dart';
import 'package:podcatcher/src/bloc/bloc.dart';
import 'package:podcatcher/src/widgets/delete_podcast_dialog.dart';
import 'package:podcatcher/src/widgets/img_or_placeholder.dart';
import 'package:podcatcher/src/widgets/podcast_provider.dart';

import 'episodes_list.dart';

class PodcastPage extends StatelessWidget {
  final int id;
  PodcastPage({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Bloc pbloc = BlocProvider.of(context);
    pbloc.fetch();

    return StreamBuilder(
      stream: pbloc.outPodcasts,
      builder: (BuildContext context, AsyncSnapshot<List<Podcast>> snapshot) {
        if (snapshot.hasData &&
            snapshot.data.length > 0 &&
            !snapshot.hasError) {
          Podcast podcast = snapshot.data.firstWhere((p) => p.id == this.id);
          return Scaffold(
            appBar: AppBar(
              title: Text(podcast.title),
            ),
            body: Column(
              children: <Widget>[
                buildInfoSection(context, podcast),
              ],
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  buildInfoSection(BuildContext context, Podcast podcast) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ImgOrPlaceholder(path: podcast.imageOffline),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Text(
                    podcast.subtitle,
                  ),
                  Text(
                    podcast.author,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete_forever),
              iconSize: 48.0,
              onPressed: () {
                _deleteDialog(context, podcast);
              },
            ),
          ],
        ),
        EpisodesList(podcastId: podcast.id),
      ],
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
