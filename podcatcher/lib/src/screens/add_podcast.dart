import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:podcatcher/src/widgets/podcast_provider.dart';
import 'package:validators/validators.dart';
import 'dart:io' show SocketException;


class AddPodcast extends StatefulWidget {
  const AddPodcast({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  _AddPodcastState createState() => _AddPodcastState();
}

class _AddPodcastState extends State<AddPodcast> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new Podcast'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            AddPodcastForm(),
            buildExplanation(),
          ],
        ),
      ),
    );
  }

  Widget buildExplanation() {
    return Padding(
      padding: EdgeInsets.only(top: 16.0),
      child: Text(
          'Try to find a RSS feed of the podcast and paste it in the Field above. The Url should end on .xml or .rss'
              .trim()),
    );
  }
}

// Create a Form Widget
class AddPodcastForm extends StatefulWidget {
  @override
  AddPodcastFormState createState() {
    return AddPodcastFormState();
  }
}

class AddPodcastFormState extends State<AddPodcastForm> {
  String _url;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _txt = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                if (!isURL(value)) {
                  return 'Please enter a valid URL.';
                }
              },
              onSaved: (url) {
                this._url = url;
              },
              controller: this._txt,
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  RaisedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();

                        PodcastBloc pbloc = PodcastBlocProvider.of(context);
                        try {
                          await pbloc.fetchFromUrl(this._url);
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text('${this._url} was processed')));
                        } on SocketException {
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text('No feed found on ${this._url}')));
                        }
                         on StateError {
                          Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text('This type of feed is not supported')));
                        }
                         catch (e) {
                          print(e);
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text('An unknown error occured: $e')));
                        }
                      }
                    },
                    child: Text('Submit'),
                  ),
                  Spacer(),
                  RaisedButton(
                    onPressed: () async {
                      ClipboardData data =
                          await Clipboard.getData('text/plain');
                      setState(() {
                        this._txt.text = data.text;
                      });
                    },
                    child: Text('Paste from clipboard'),
                  ),
                ],
              ),
            ),
          ]),
    );
  }
}
