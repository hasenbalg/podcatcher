import 'package:flutter/material.dart';
import 'package:podcatcher/src/widgets/episode_text.dart';

import '../model/episode.dart';
import 'img_or_placeholder.dart';

class EpisodePage extends StatelessWidget {
  final Episode episode;
  EpisodePage({Key key, this.episode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(episode.title),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                height: 200,
                child: ImgOrPlaceholder(
                  path: episode.imageOffline,
                ),
              ),
              EpisodeText(episode),
            ],
          ),
        ),
      ),
    );
  }
}
