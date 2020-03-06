import 'package:http/http.dart';

import '../model/episode.dart';
import 'database_helper.dart';
import 'download_file.dart';

class EpisodeRepo with DownloadFile {
  String _tableName = 'Episodes';

  Client client = Client();

  fetchAllOfPodcast(int podcastId) async {
    var result = await DatabaseHelper.instance
        .queryWhereFieldIs(_tableName, 'podcast_id', podcastId);
    return result.map((dbMap) => Episode.fromDb(dbMap)).toList();
  }
}
