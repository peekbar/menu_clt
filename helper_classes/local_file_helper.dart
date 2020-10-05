import 'dart:io';

import '../models/models.dart';

class LocalFileHelper {
  // copies all files inside the web direcory to a local menu
  void copyAllFilesTo(Menu menu) {
    var directory = getMenuDirectory(menu);

    if (directory.existsSync()) {
      Process.runSync('rm', ['-r', getMenuDirectory(menu).path + '/*']);
    }

    Process.runSync('cp', ['-r', 'web/*', getMenuDirectory(menu).path]);
  }

  // returns a list of the local menu names
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

  // returns true, if the menu is locally present
  bool isLocalMenuPresent(Menu menu) {
    return getMenuDirectory(menu).existsSync();
  }

  // returns the local directory of a menu
  Directory getMenuDirectory(Menu menu) {
    if (menu.firebase) {
      return Directory('menus/' + menu.menuName + '/public');
    } else {
      return Directory('menus/' + menu.menuName);
    }
  }

  // returns the local file
  File getFile(Menu menu, String fileName) {
    if (menu.firebase) {
      return File('menus/' + menu.menuName + '/public/' + fileName);
    } else {
      return File('menus/' + menu.menuName + '/' + fileName);
    }
  }

  // deletes a local menu by the menu name
  void deleteLocalMenu(String menuName) {
    Process.runSync('rm', ['-r', 'menus/' + menuName]);
  }
}
