import 'dart:convert';

import 'package:http/http.dart';
import 'package:podcatcher/resources/database_helper.dart';
import 'package:podcatcher/src/models/podcast.dart';
export 'package:podcatcher/src/models/podcast.dart';

class PodcastRepository {
  String _tableName = 'Podcasts';

  Client client = Client();

  Future fetchFromUrl(String url) async {
    var response = await client.get(url);
    Podcast newPodcast = Podcast.fromRss(utf8.decode(response.bodyBytes));

    List<Podcast> allPodcasts = await fetchFromDb();
    allPodcasts.forEach((oldPodcast) {
      if (oldPodcast.feedLink == newPodcast.feedLink) {
        throw DuplicateException('Allready subscribed.');
      }
    });

    await DatabaseHelper.instance.insert(newPodcast.toDb(), _tableName);
    print('${newPodcast.title} in database');
  }

 

  Future<List<Podcast>> fetchFromDb() async {
    var result = await DatabaseHelper.instance.queryAllRows(_tableName);
    return result.map((dbMap) => Podcast.fromDb(dbMap)).toList();
  }

  clearCache() async {
    await DatabaseHelper.instance.clear(_tableName);
  }

  void updateSingle(Podcast p) async {
    Podcast newP = await fetchFromUrl(p.feedLink);
    newP.id = p.id;
    await DatabaseHelper.instance.update(newP.toDb(), _tableName);
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
}

class DuplicateException implements Exception {
  String cause;
  DuplicateException(this.cause);
}
