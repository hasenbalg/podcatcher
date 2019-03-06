import 'package:podcatcher/src/models/episode.dart';
import 'package:xml/xml.dart' as xml;

class Podcast {
  String title;
  String author;
  bool explicit = true;
  String subtitle;
  String image;
  String feedLink;
  List<Episode> episodes;

  Podcast(
      {this.title,
      this.author,
      this.subtitle,
      this.feedLink,
      this.image,
      this.episodes,
      this.explicit});

  Podcast.fromJson(parsedJson) {
    this.title = parsedJson['title'];
    this.author = parsedJson['author'];
    this.subtitle = parsedJson['subtitle'];
    this.feedLink = parsedJson['link'];
    this.image = parsedJson['image'];
    this.episodes = parsedJson['episodes'];
    this.explicit = parsedJson['explicit'];
  }

  Podcast.fromXML(String podcastXml) {
    final document = xml.parse(podcastXml);
    final channelNode = document.findAllElements('channel').first;

    this.title = channelNode.findElements('title').first.text;
    this.author = channelNode.findElements('itunes:author').first.text;
    this.subtitle = channelNode.findElements('itunes:subtitle').first.text;
    this.feedLink = channelNode.findElements('link').first.text;
    this.image =
        channelNode.findElements('image').first.findElements('url').first.text;
    this.episodes =
        channelNode.findElements('item').map((item) => Episode.fromXML(item)).toList();
    this.explicit =
        channelNode.findElements('itunes:explicit').first.text != 'no';

        print(episodes.length);
  }
}
