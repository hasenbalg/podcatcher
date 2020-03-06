import 'dart:io';

import 'package:flutter/material.dart';

class ImgOrPlaceholder extends StatelessWidget {
  String path;

  ImgOrPlaceholder({key, this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Image img;
    try {
      img = Image.file(
        File(path),
        fit: BoxFit.cover,
        height: 70,
      );
    } catch (e) {
      img = Image.asset(
        'images/placeholder.png',
        fit: BoxFit.cover,
        height: 70,
      );
    }
    return img;
  }
}
