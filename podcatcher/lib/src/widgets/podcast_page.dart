import 'dart:io';

import 'package:flutter/material.dart';
import 'package:podcatcher/src/widgets/img_or_placeholder.dart';
import 'package:podcatcher/src/widgets/podcast_provider.dart';

class PodcastPage extends StatelessWidget {
  final int id;
  PodcastPage({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PodcastBloc pbloc = PodcastBlocProvider.of(context);
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
            ImgOrPlaceholder(path: podcast.imageOffline),
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

                // Navigator.pop(context);
              },
            ),
          ],
        )
      ],
    );
  }

  Future<void> _deleteDialog(BuildContext context, Podcast podcast) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Really delete ${podcast.title}?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are your sure?'),
                Text('This is not reversable.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                PodcastBloc pbloc = PodcastBlocProvider.of(context);
                //delete file
                var file = File(podcast.imageOffline);
                file.deleteSync();
                
                pbloc.delete(podcast.id);
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
