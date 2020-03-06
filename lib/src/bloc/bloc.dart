import 'dart:async';

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

  void fetchPodcasts() async {
    List<Podcast> podcasts = await PodcastRepo().fetchFromDb();
    _podcasts.sink.add(podcasts);
  }

  fetchFromUrl(String url) async {
    await PodcastRepo().fetchFromUrl(url);
  }

  Future updateAll() async {
    PodcastRepo().updateAll();
    fetchPodcasts();
  }

  void dispose() {
    _podcasts.close();
    _episodes.close();
  }

  Future clearCache() async {
    await PodcastRepo().clearCache();
  }

  Future deletePodcast(Podcast podcast) async {
    await PodcastRepo().delete(podcast);
    // delete all episodes belonging to this podcast
    for (Episode e in await EpisodeRepo().fetchAllOfPodcast(podcast.id)) {
      EpisodeRepo().delete(e).then((_) => print('deleting ${e.id}'));
    }
  }

  Future<void> fetchEpisodesOf(int podcastId) async {
    List<Episode> episodes = await EpisodeRepo().fetchAllOfPodcast(podcastId);
    _episodes.sink.add(episodes);
  }

  Future<void> fetchEpisode(int id) async {
    Episode episode = await EpisodeRepo().fetchEpisode(id);
    _episodes.sink.add([episode]);
  }
}
