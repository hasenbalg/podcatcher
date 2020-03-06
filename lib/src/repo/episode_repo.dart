import 'package:http/http.dart';
import 'package:podcatcher/src/model/podcast.dart';

import '../model/episode.dart';
import 'database_helper.dart';
import 'download_file.dart';

class EpisodeRepo with DownloadFile {
  String _tableName = 'Episodes';

  Client client = Client();

  fetchAllOfPodcast(int podcastId) async {
    var result = await DatabaseHelper.instance
        .queryWhereFieldIs(_tableName, 'podcastId', podcastId);
    return result.map((dbMap) => Episode.fromDb(dbMap)).toList();
  }

  Future<Episode> fetchEpisode(int id) async {
    var result =
        await DatabaseHelper.instance.queryWhereFieldIs(_tableName, 'id', id);
    return result.map((dbMap) => Episode.fromDb(dbMap)).first;
  }

  Future<void> updateEpisodesOfPodcast(Podcast podcast) async {
    // print(podcast.episodes);
    List<Episode> oldEpisodesOfThisPodcast =
        await fetchAllOfPodcast(podcast.id);
    for (Episode e in podcast.episodes) {
      Episode oldEpisode = oldEpisodesOfThisPodcast.firstWhere(
          (oe) => oe.audioOnline == e.audioOnline,
          orElse: () => null);
      if (oldEpisode == null) {
        e.podcastId = podcast.id;
        e.imageOnline ??= podcast.imageOnline;
        e.imageOffline ??= podcast.imageOffline;
        await DatabaseHelper.instance.insert(e.toDb(), _tableName);
      }
    }
  }

  Future<void> delete(int id) async {
    await DatabaseHelper.instance.delete(id, _tableName);
  }
}
