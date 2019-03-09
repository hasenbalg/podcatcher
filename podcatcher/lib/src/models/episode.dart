import 'package:intl/intl.dart';
import 'package:xml/xml.dart' as xml;

class Episode {
  int id;
  String title;
  String author;
  String description;
  String audioOnline;
  String audioOffline;
  DateTime pubDate;
  int duration; // in seconds
  bool isDownloaded = false;
  String imageOnline;
  String imageOffline;
  int timePlayed = 0;

  static String createTable = '''
  CREATE TABLE Episodes(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    podcast_id INT NOT NULL,
    title TEXT NOT NULL,
    author TEXT,
    description TEXT,
    audioOnline TEXT NOT NULL,
    audioOffline TEXT,
    pubDate INT NOT NULL,
    duration INT NOT NULL,
    isDownloaded INT NOT NULL DEFAULT 0,
    imageOnline TEXT,
    imageOffline TEXT,
    timePlayed INT NOT NULL DEFAULT 0,
    FOREIGN KEY(podcast_id) REFERENCES Podcasts(id)
  )
  ''';

  Episode(
      {this.id,
      this.title,
      this.author,
      this.description,
      this.audioOnline,
      this.audioOffline,
      this.pubDate,
      this.duration,
      this.isDownloaded,
      this.imageOnline,
      this.imageOffline,
      this.timePlayed});

  Episode.fromJson(parsedJson) {
    this.id = parsedJson['id'] as int;
    this.author = parsedJson['author'];
    this.description = parsedJson['description'];
    this.title = parsedJson['title'];
    this.audioOnline = parsedJson['audioOnline'];
    this.pubDate = parsedJson['pubDate'];
    this.duration = parsedJson['duration'];
    this.audioOffline = parsedJson['audioOffline'];
    this.isDownloaded = parsedJson['isDownloaded'];
    this.imageOnline = parsedJson['imageOnline'];
    this.imageOffline = parsedJson['imageOffline'];
    this.timePlayed = parsedJson['timePlayed'];
  }

  Episode.fromDb(Map<String, dynamic> dbMap) {
    this.id = dbMap['id'] as int;
    this.author = dbMap['author'];
    this.description = dbMap['description'];
    this.title = dbMap['title'];
    this.audioOnline = dbMap['audioOnline'];
    this.audioOffline = dbMap['audioOffline'];
    this.pubDate = DateTime.fromMicrosecondsSinceEpoch(dbMap['pubDate']);
    this.duration = dbMap['duration'] as int;
    this.isDownloaded = dbMap['isDownloaded'] == 1;
    this.imageOnline = dbMap['imageOnline'];
    this.imageOffline = dbMap['imageOffline'];
    this.timePlayed = dbMap['timePlayed'] as int;
  }

  Map<String, dynamic> toDb() {
    return {
      'id': this.id,
      'author': this.author,
      'description': this.description,
      'title': this.title,
      'audioOnline': this.audioOnline,
      'audioOffline': this.audioOffline,
      'pubDate': this.pubDate.millisecondsSinceEpoch,
      'duration': this.duration,
      'isDownloaded': this.isDownloaded ? 1 : 0,
      'imageOnline': this.imageOnline,
      'imageOffline': this.imageOffline,
      'timePlayed': this.timePlayed,
    };
  }

  Episode.fromRss(xml.XmlElement item) {
    this.title = item.findElements('title').first.text;
    this.pubDate = _parseDate(
        'E, d MMM yyyy HH:mm:ss Z', item.findElements('pubDate').first.text);
    this.author = (item.findElements('author').isNotEmpty)
        ? item.findElements('author').first.text
        : '';
    this.description = item.findElements('description').first.text;
    this.duration = _findDuration(item);
    this.audioOnline =
        item.findElements('enclosure').first.getAttribute('audioOnline');
    this.imageOnline = (item.findElements('img').isNotEmpty)
        ? item.findElements('img').first.getAttribute('src')
        : null;
  }

  _parseDate(String format, String date) {
    return new DateFormat(format).parse(date);
  }

  int _findDuration(xml.XmlElement item) {
    try {
      return int.parse(
          item.findElements('enclosure').first.getAttribute('length'));
    } catch (e) {
      return null;
    }
  }
}
