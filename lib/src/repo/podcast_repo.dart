import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:podcatcher/src/model/podcast.dart';
import 'package:podcatcher/src/repo/episode_repo.dart';

import 'database_helper.dart';
import 'download_file.dart';

class PodcastRepo with DownloadFile {
  String _tableName = 'Podcasts';

  Client client = Client();

  Future fetchFromUrl(String url) async {
    var response = await client.get(url);
    Podcast newPodcast = Podcast.fromRss(utf8.decode(response.bodyBytes));
    newPodcast.feedLink ??= url;

    newPodcast.imageOffline = await downloadAndGetPath(newPodcast.imageOnline);

    List<Podcast> allPodcasts = await fetchFromDb();

    //  Podcast oldPodcast =
    //       allPodcasts.firstWhere((p) => p.feedLink == newPodcast.feedLink);
    //       print(oldPodcast);
    //   if (oldPodcast != null) {
    //     newPodcast.id = oldPodcast.id;
    //     await DatabaseHelper.instance.update(newPodcast.toDb(), _tableName);
    //   } else {
    //     await DatabaseHelper.instance.insert(newPodcast.toDb(), _tableName);
    //   }

    allPodcasts.forEach((oldPodcast) async {
      if (oldPodcast.feedLink == newPodcast.feedLink) {
        newPodcast.id = oldPodcast.id;
        await DatabaseHelper.instance.update(newPodcast.toDb(), _tableName);
      }
    });
    if (newPodcast.id == null) {
      newPodcast.id =
          await DatabaseHelper.instance.insert(newPodcast.toDb(), _tableName);
    }
    print('$newPodcast in database');
    EpisodeRepo().updateEpisodesOfPodcast(newPodcast);
  }

  Future<List<Podcast>> fetchFromDb() async {
    var result = await DatabaseHelper.instance.queryAllRows(_tableName);
    return result.map((dbMap) => Podcast.fromDb(dbMap)).toList();
  }

  clearCache() async {
    await DatabaseHelper.instance.clear(_tableName);
  }

  void updateSingle(Podcast p) async {
    fetchFromUrl(p.feedLink);
  }

  Future updateAll() async {
    var allPodcastsFromDb =
        await DatabaseHelper.instance.queryAllRows(_tableName);
    List<Podcast> allPodcasts =
        allPodcastsFromDb.map((p) => Podcast.fromDb(p)).toList();

    allPodcasts.forEach((p) async {
      updateSingle(p);
    });
  }

  Future delete(Podcast p) async {
    try {
      //delete file
      var file = File(p.imageOffline);
      file.deleteSync();
    } catch (e) {} finally {
      await DatabaseHelper.instance.delete(p.id, _tableName);
    }
  }
}
