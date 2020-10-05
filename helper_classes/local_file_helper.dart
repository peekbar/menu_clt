import 'dart:io';

import '../models/models.dart';

class LocalFileHelper {
  // add all the files to the new directory (delete before copying)
  void copyAllFilesTo(Menu menu) {
    var directory = getMenuDirectory(menu);

    if (directory.existsSync()) {
      Process.runSync('rm', ['-r', getMenuDirectory(menu).path + '/*']);
    }

    Process.runSync('cp', ['-r', 'web/*', getMenuDirectory(menu).path]);
  }

  List<String> getLocalMenuNames() {
    List<String> localMenus = [];
    List<FileSystemEntity> entityList =
        Directory('menus').listSync(recursive: false, followLinks: false);

    for (FileSystemEntity entity in entityList) {
      if (FileSystemEntity.isDirectorySync(entity.path)) {
        var path = entity.path.split('/');
        localMenus.add(path[path.length - 1]);
      }
    }
    return localMenus;
  }

  bool isLocalMenuPresent(Menu menu) {
    return getMenuDirectory(menu).existsSync();
  }

  Directory getMenuDirectory(Menu menu) {
    if (menu.firebase) {
      return Directory('menus/' + menu.menuName + '/public');
    } else {
      return Directory('menus/' + menu.menuName);
    }
  }

  File getFile(Menu menu, String fileName) {
    if (menu.firebase) {
      return File('menus/' + menu.menuName + '/public/' + fileName);
    } else {
      return File('menus/' + menu.menuName + '/' + fileName);
    }
  }

  void deleteLocalMenu(String menuName) {
    Process.runSync('rm', ['-r', 'menus/' + menuName]);
  }
}
