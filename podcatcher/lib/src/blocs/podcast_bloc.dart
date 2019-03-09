import 'dart:async';
import 'package:podcatcher/resources/podcast_repository.dart';
import 'package:podcatcher/src/models/podcast.dart';

export 'package:podcatcher/src/models/podcast.dart';

class PodcastBloc {
  StreamController<List<Podcast>> _podcasts = StreamController.broadcast();

  Stream<List<Podcast>> get outPodcasts => _podcasts.stream;

  void fetch() async {
    List<Podcast> podcasts = await PodcastRepository().fetchFromDb();
    _podcasts.sink.add(podcasts);
  }

  fetchFromUrl(String url) async {
    await PodcastRepository().fetchFromUrl(url);
  }

  Future updateAll() async {
    PodcastRepository().updateAll();
    fetch();
  }

  void dispose() {
    _podcasts.close();
  }

  Future clearCache() async {
    await PodcastRepository().clearCache();
  }
}
