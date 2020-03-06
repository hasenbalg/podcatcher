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

      File file = File(join(docDir.path, fileName));
      if (await file.exists()) {
        return file.path;
      }
      Client c = Client();
      var response = await c.get(online);
      file.create(recursive: true);
      await file.writeAsBytes(response.bodyBytes);
      return file.path;
    } catch (e) {
      return null;
    }
  }
}
