import 'dart:async';
import 'dart:io';

import 'package:podcatcher/src/model/podcast.dart';
import 'package:podcatcher/src/repo/episode_repo.dart';
import 'package:podcatcher/src/repo/podcast_repo.dart';

import '../model/episode.dart';

export 'package:podcatcher/src/model/podcast.dart';

class Bloc {
  StreamController<List<Podcast>> _podcasts = StreamController.broadcast();
  StreamController<List<Episode>> _episodes = StreamController.broadcast();

  Stream<List<Podcast>> get outPodcasts => _podcasts.stream;
  Stream<List<Episode>> get outEpisodes => _episodes.stream;

  void fetch() async {
    List<Podcast> podcasts = await PodcastRepo().fetchFromDb();
    _podcasts.sink.add(podcasts);
  }

  fetchFromUrl(String url) async {
    await PodcastRepo().fetchFromUrl(url);
  }

  Future updateAll() async {
    PodcastRepo().updateAll();
    fetch();
  }

  void dispose() {
    _podcasts.close();
    _episodes.close();
  }

  Future clearCache() async {
    await PodcastRepo().clearCache();
  }

  Future delete(Podcast podcast) async {
    //delete file
    var file = File(podcast.imageOffline);
    file.deleteSync();
    await PodcastRepo().delete(podcast.id);
  }

  Future<void> fetchEpisodesOf(int podcastId) async {
    List<Episode> episodes = await EpisodeRepo().fetchAllOfPodcast(podcastId);
    _episodes.sink.add(episodes);
  }
}
