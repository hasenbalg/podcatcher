import 'package:flutter/material.dart';
import 'package:podcatcher/src/widgets/img_or_placeholder.dart';
import 'package:podcatcher/src/widgets/podcast_page.dart';
import 'package:podcatcher/src/widgets/podcast_provider.dart';
import 'package:podcatcher/src/widgets/podcast_refresh.dart';


class PodcastsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Bloc pbloc = BlocProvider.of(context);
    pbloc.fetchPodcasts();
    return PodcastRefresh(
      child: StreamBuilder(
        stream: pbloc.outPodcasts,
        builder: (BuildContext context, AsyncSnapshot<List<Podcast>> snapshot) {
          if (snapshot.hasData &&
              snapshot.data.length > 0 &&
              !snapshot.hasError) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Podcast p = snapshot.data[index];
                return buildPodcastListTile(context, p);
              },
            );
          }else if(snapshot.data?.length == 0){
            return Center(child: Text('No Podcasts found'),);
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  ListTile buildPodcastListTile(BuildContext context, Podcast podcast) {
    return ListTile(
      leading: ImgOrPlaceholder(path: podcast.imageOffline),
      title: Text(podcast.title),
      subtitle: Text(podcast.subtitle),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PodcastPage(
                  podcast: podcast,
                ),
          ),
        );
      },
    );
  }
}
