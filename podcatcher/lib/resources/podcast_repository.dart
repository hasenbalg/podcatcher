import 'package:http/http.dart';
import 'package:podcatcher/src/models/podcast.dart';

export 'package:podcatcher/src/models/podcast.dart';

class PodcastRepository {
  Client client = Client();
   fetch(String url) async {
     var response = await client.get(url);
     return Podcast.fromXML(response.body);

  }
}