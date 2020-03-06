import 'package:flutter/material.dart';
import 'package:podcatcher/src/bloc/bloc.dart';
import 'package:podcatcher/src/model/podcast.dart';
import 'package:podcatcher/src/widgets/podcast_provider.dart';

class DeletePodcastDialog extends StatelessWidget {
  final Podcast podcast;

  DeletePodcastDialog({key, this.podcast}) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
          onPressed: () async {
            Bloc bloc = BlocProvider.of(context);

            bloc.deletePodcast(podcast);
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
  }
}
