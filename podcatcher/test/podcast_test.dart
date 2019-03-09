import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:podcatcher/src/models/podcast.dart';

void main() {
  List<String> urls = [
    'ctuplink.xml',
    'd0d9378f-add4-4449-977f-71e52331472d.xml',
    'devonfire.xml',
    'lattnyheter2.xml',
    // 'lattnyheter.xml',
    'podcast-softwarearchitektour.xml',
    'topnews-audio.xml',
    'p02nq0lx.rss'
  ];

  test('Fetch from different Rss feed', () async {
    var response =
        await Client().get('https://hasenbalg.org/testfeeds/${urls[0]}');
    var pod = Podcast.fromRss(response.body);
    print(pod);
    expect(pod.runtimeType, Podcast);
  });

   test('Fetch from different Rss feed', () async {
    var response =
        await Client().get('https://hasenbalg.org/testfeeds/${urls[1]}');
    var pod = Podcast.fromRss(response.body);
    print(pod);
    expect(pod.runtimeType, Podcast);
  });

   test('Fetch from different Rss feed', () async {
    var response =
        await Client().get('https://hasenbalg.org/testfeeds/${urls[2]}');
    var pod = Podcast.fromRss(response.body);
    print(pod);
    expect(pod.runtimeType, Podcast);
  });

   test('Fetch from different Rss feed', () async {
    var response =
        await Client().get('https://hasenbalg.org/testfeeds/${urls[3]}');
    var pod = Podcast.fromRss(response.body);
    print(pod);
    expect(pod.runtimeType, Podcast);
  });

   test('Fetch from different Rss feed', () async {
    var response =
        await Client().get('https://hasenbalg.org/testfeeds/${urls[4]}');
    var pod = Podcast.fromRss(response.body);
    print(pod);
    expect(pod.runtimeType, Podcast);
  });

   test('Fetch from different Rss feed', () async {
    var response =
        await Client().get('https://hasenbalg.org/testfeeds/${urls[5]}');
    var pod = Podcast.fromRss(response.body);
    print(pod);
    expect(pod.runtimeType, Podcast);
  });

   test('Fetch from different Rss feed', () async {
    var response =
        await Client().get('https://hasenbalg.org/testfeeds/${urls[6]}');
    var pod = Podcast.fromRss(response.body);
    print(pod);
    expect(pod.runtimeType, Podcast);
  });

 
}
