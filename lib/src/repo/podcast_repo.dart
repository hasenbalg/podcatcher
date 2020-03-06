import 'dart:convert';

import 'package:http/http.dart';
import 'package:podcatcher/src/model/podcast.dart';

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
    allPodcasts.forEach((oldPodcast) async {
      if (oldPodcast.feedLink == newPodcast.feedLink) {
        newPodcast.id = oldPodcast.id;
        await DatabaseHelper.instance.update(newPodcast.toDb(), _tableName);
      }
    });

    await DatabaseHelper.instance.insert(newPodcast.toDb(), _tableName);
    print('$newPodcast in database');
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

  Future delete(int id) async {
    await DatabaseHelper.instance.delete(id, _tableName);
  }
}