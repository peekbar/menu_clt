import 'dart:io';

class LocalFileHelper {
  // copies all files inside the web direcory to a local menu
  void copyAllFilesTo(String name) {
    var directory = getMenuDirectory(name);

    if (directory.existsSync()) {
      Process.runSync('rm', ['-rf', getMenuDirectory(name).path]);
    }

    Process.runSync('cp', ['-rf', 'web', getMenuDirectory(name).path]);
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
  bool isLocalMenuPresent(String name) {
    return getMenuDirectory(name).existsSync();
  }

  // returns the local directory of a menu
  Directory getMenuDirectory(String name) {
    return Directory('menus/' + name);
  }

  // returns the local file
  File getFile(String name, String fileName) {
    return File('menus/' + name + '/' + fileName);
  }

  // deletes a local menu by the menu name
  void deleteLocalMenu(String name) {
    Process.runSync('rm', ['-r', 'menus/' + name]);
  }
}
