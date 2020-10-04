import 'dart:io';

import '../models/models.dart';

class LocalFileHelper {
  // add all the files to the new directory (delete before copying)
  void copyAllFilesTo(Menu menu) async {
    var directory = await new Directory('menus/' + menu.menuName);

    if (await directory.exists()) {
      await directory.deleteSync(recursive: true);
    }

    await directory.create(recursive: true);

    await Process.runSync('cp', ['-r', 'web', 'menus/web']);
    await new Directory('menus/web').rename('menus/' + menu.menuName);
  }
}
