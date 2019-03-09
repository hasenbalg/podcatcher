import 'package:flutter/material.dart';
import 'package:podcatcher/src/screens/home.dart';
import 'package:podcatcher/src/widgets/podcast_provider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PodcastBlocProvider(
      bloc: PodcastBloc(),
      child: MaterialApp(
        title: 'Podcatcher',
        theme: ThemeData(
          primarySwatch: Colors.lightGreen,
        ),
        home: Home(title: 'Podcatcher'),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => Home(title: 'Podcatcher'),
        },
      ),
    );
  }
}
