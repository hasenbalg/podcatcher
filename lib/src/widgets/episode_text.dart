import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/episode.dart';

class EpisodeText extends StatelessWidget {
  Episode e;
  DateFormat dateFormat = DateFormat.yMMMMEEEEd();
  EpisodeText(this.e);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: Text(
              '${e.title}',
              style: Theme.of(context).textTheme.title,
            ),
          ),
          Text(
            '${dateFormat.format(e.pubDate)}',
            textAlign: TextAlign.left,
          ),
          Text('${e.description}')
        ],
      ),
    );
  }
}
