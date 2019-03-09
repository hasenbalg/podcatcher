import 'package:flutter/material.dart';
import 'package:podcatcher/src/screens/add_podcast.dart';
import 'package:podcatcher/src/widgets/podcasts_list.dart';

class Home extends StatelessWidget {
  Home({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    
    // pbloc.fetchFromUrl('https://hasenbalg.org/lattnyheter2.xml');
    // pbloc.fetchFromUrl('https://hasenbalg.org/devonfire.xml');
    // pbloc.fetchFromUrl(
    //     'https://hasenbalg.org/d0d9378f-add4-4449-977f-71e52331472d.xml');
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: PodcastsList(),
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

 
}
