import 'package:podcatcher/src/models/episode.dart';
import 'package:xml/xml.dart' as xml;

class Podcast {
  int id;
  String title;
  String author;
  bool explicit = true;
  String subtitle;
  String imageOnline;
  String imageOffline;
  String feedLink;
  List<Episode> episodes;

  static String createTable = '''
  CREATE TABLE Podcasts(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    author TEXT,
    explicit INTEGER NOT NULL DEFAULT 1,
    subtitle TEXT,
    imageOnline TEXT,
    imageOffline TEXT,
    feedLink TEXT NOT NULL
  )
  ''';


  Podcast(
      {this.id,
      this.title,
      this.author,
      this.subtitle,
      this.feedLink,
      this.imageOnline,
      this.imageOffline,
      this.explicit});

  Podcast.fromJson(parsedJson) {
    this.id = parsedJson['id'];
    this.title = parsedJson['title'];
    this.author = parsedJson['author'];
    this.subtitle = parsedJson['subtitle'];
    this.feedLink = parsedJson['link'];
    this.imageOnline = parsedJson['imageOnline'];
    this.imageOffline = parsedJson['imageOffline'];
    this.explicit = parsedJson['explicit'];
  }

  Podcast.fromDb(Map<String, dynamic> dbMap) {
    this.id = dbMap['id'] as int;
    this.title = dbMap['title'];
    this.author = dbMap['author'];
    this.subtitle = dbMap['subtitle'];
    this.feedLink = dbMap['feedLink'];
    this.imageOnline = dbMap['imageOnline'];
    this.imageOffline = dbMap['imageOffline'];
    this.explicit = dbMap['explicit'] == 1;
  }

  Podcast.fromRss(String podcastXml) {
    final document = xml.parse(podcastXml);
    final channelNode = document.findAllElements('channel').first;

    this.title = channelNode.findElements('title').first.text;
    this.author = channelNode.findElements('itunes:author').first.text;
    this.subtitle = (channelNode.findElements('itunes:subtitle').isNotEmpty)
        ? channelNode.findElements('itunes:subtitle').first.text
        : '';
    this.feedLink = channelNode.findElements('link').first.text;
    this.imageOnline =
        channelNode.findElements('image').first.findElements('url').first.text;
    this.episodes = channelNode
        .findElements('item')
        .map((item) => Episode.fromRss(item))
        .toList();
    this.explicit =
        channelNode.findElements('itunes:explicit').first.text != 'no';

    print('${this.episodes.length} Episodes in ${this.title}');
  }

  Map<String, dynamic> toDb() {
    return {
      'id': this.id,
      'title': this.title,
      'author': this.author,
      'subtitle': this.subtitle,
      'feedLink': this.feedLink,
      'imageOnline': this.imageOnline,
      'imageoffline': this.imageOffline,
      'explicit': this.explicit ? 1 : 0,
    };
  }
}
