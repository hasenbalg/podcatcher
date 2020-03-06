import 'package:flutter/material.dart';
import 'package:podcatcher/src/screens/home.dart';
import 'package:podcatcher/src/widgets/podcast_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: Bloc(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Home(title: 'Podcatcher'),
      ),
    );
  }
}
