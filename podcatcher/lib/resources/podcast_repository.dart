import 'dart:convert';

import 'package:http/http.dart';
import 'package:podcatcher/resources/database_helper.dart';
import 'package:podcatcher/src/models/podcast.dart';
export 'package:podcatcher/src/models/podcast.dart';

class PodcastRepository {
  String _tableName = 'Podcasts';

  Client client = Client();

  void fetchFromUrl(String url) async {
    var response = await client.get(url);
    Podcast p = Podcast.fromRss(utf8.decode(response.bodyBytes));
    await DatabaseHelper.instance.insert(p.toDb(), _tableName);
  }

  fetchFromDb() async {
    var result = await DatabaseHelper.instance.queryAllRows(_tableName);
    return result.map((dbMap) => Podcast.fromDb(dbMap)).toList();
  }
}
