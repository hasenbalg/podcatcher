import 'dart:io';

import 'package:flutter/material.dart';
import 'package:podcatcher/src/widgets/episode_text.dart';

import '../model/episode.dart';
import 'img_or_placeholder.dart';
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
          return _buildEpisodeDetails(snapshot.data, context);
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

  Widget _buildEpisodeDetails(List<Episode> data, BuildContext context) {
    Episode e = data.firstWhere((e) => e.id == id);
    return Scaffold(
      appBar: AppBar(
        title: Text(e.title),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ImgOrPlaceholder(
                path: e.imageOffline,
              ),
            ),
            EpisodeText(e),
          ],
        ),
      ),
    );
  }
}
