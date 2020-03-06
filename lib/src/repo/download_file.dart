import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart';

class DownloadFile {
  Future<String> downloadAndGetPath(String online) async {
    try {
      var docDir = await getApplicationDocumentsDirectory();
      String fileName = online
          .split('/')
          .last
          .replaceAll(new RegExp(r'\?.+'), ''); //remove all ending

      Client c = new Client();
      var response = await c.get(online);
      File file = new File(join(docDir.path, fileName));
      file.create(recursive: true);
      await file.writeAsBytes(response.bodyBytes);
      return file.path;
    } catch (e) {
      return null;
    }
  }
}