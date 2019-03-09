import 'package:flutter/material.dart';
import 'package:podcatcher/src/screens/add_podcast.dart';
import 'package:podcatcher/src/widgets/podcast_provider.dart';
import 'package:podcatcher/src/widgets/podcast_refresh.dart';

class Home extends StatelessWidget {
  Home({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    PodcastBloc pbloc = PodcastBlocProvider.of(context);
    pbloc.fetch();
    // pbloc.fetchFromUrl('https://hasenbalg.org/lattnyheter2.xml');
    // pbloc.fetchFromUrl('https://hasenbalg.org/devonfire.xml');
    // pbloc.fetchFromUrl(
    //     'https://hasenbalg.org/d0d9378f-add4-4449-977f-71e52331472d.xml');
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: PodcastRefresh(
        child: StreamBuilder(
          stream: pbloc.outPodcasts,
          builder:
              (BuildContext context, AsyncSnapshot<List<Podcast>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  Podcast p = snapshot.data[index];
                  return buildPodcastListTile(p);
                },
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AddPodcast()),
  );
        },
        tooltip: 'Add a new Podcast RSS',
        child: Icon(Icons.add),
      ),
    );
  }

  ListTile buildPodcastListTile(Podcast p) {
    return ListTile(
      leading: Image.network(
        p.imageOnline,
        fit: BoxFit.cover,
        height: 70,
      ),
      title: Text(p.title),
      subtitle: Text(p.subtitle),
    );
  }
}
