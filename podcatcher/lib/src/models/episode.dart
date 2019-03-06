import 'package:xml/src/xml/nodes/element.dart';
import 'package:intl/intl.dart';

class Episode {
  String title;
  String author;
  String description;
  String url;
  DateTime pubDate;
  int duration; // in seconds
  String localPath;
  bool isDownloaded = false;
  int timePlayed = 0;

  Episode(
      {this.title,
      this.author,
      this.description,
      this.url,
      this.pubDate,
      this.duration,
      this.localPath,
      this.isDownloaded,
      this.timePlayed});

  Episode.fromJson(parsedJson) {
    this.author = parsedJson['author'];
    this.description = parsedJson['description'];
    this.title = parsedJson['title'];
    this.url = parsedJson['url'];
    this.pubDate = parsedJson['pubDate'];
    this.duration = parsedJson['duration'];
    this.localPath = parsedJson['localPath'];
    this.isDownloaded = parsedJson['isDownloaded'];
    this.timePlayed = parsedJson['timePlayed'];
  }

  Episode.fromXML(XmlElement item) {
    this.title = item.findElements('title').first.text;
    this.pubDate = _parseDate('E, d MMM yyyy HH:mm:ss Z',
        item.findElements('pubDate').first.text);
    this.author = item.findElements('author').first.text;
    this.description = item.findElements('description').first.text;
    this.duration =
        int.parse(item.findElements('enclosure').first.getAttribute('length'));
    this.url = item.findElements('enclosure').first.getAttribute('url');
  }

  _parseDate(String format, String date) {
    // DateFormat format = new DateFormat("EEE, dd MMM yyyy hh:mm a zzz");
    return new DateFormat(format).parse(date);
  }
}
