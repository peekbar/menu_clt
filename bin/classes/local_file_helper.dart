import 'dart:io';

class LocalFileHelper {
  // copies all files inside the web direcory to a local menu
  void copyAllFilesTo(Directory source, Directory destination) {
    if (destination.existsSync()) {
      Process.runSync('rm', ['-rf', destination.path]);
    }

    Process.runSync('cp', ['-rf', source.path, destination.path]);
  }

  // returns a list of the menu names in data
  List<String> getMenusInData() {
    List<String> menus = [];
    List<FileSystemEntity> entityList =
        Directory('menu/data').listSync(recursive: false, followLinks: false);

    for (FileSystemEntity entity in entityList) {
      if (FileSystemEntity.isFileSync(entity.path)) {
        var path = entity.path.split('/');
        menus.add(path[path.length - 1].replaceAll('.json', ''));
      }
    }

    return menus;
  }

  // returns a list of the menu names in generated
  List<String> getMenusInGenerated() {
    List<String> menus = [];
    List<FileSystemEntity> entityList = Directory('menu/generated')
        .listSync(recursive: false, followLinks: false);

    for (FileSystemEntity entity in entityList) {
      if (FileSystemEntity.isDirectorySync(entity.path)) {
        var path = entity.path.split('/');
        menus.add(path[path.length - 1]);
      }
    }

    return menus;
  }

  // returns a list of the available templates
  List<String> getTemplates() {
    List<String> templates = [];
    List<FileSystemEntity> entityList = Directory('menu/templates')
        .listSync(recursive: false, followLinks: false);

    for (FileSystemEntity entity in entityList) {
      if (FileSystemEntity.isDirectorySync(entity.path)) {
        var path = entity.path.split('/');
        templates.add(path[path.length - 1]);
      }
    }

    return templates;
  }

  // returns the contents of a file
  String getContents(File file) {
    return file.readAsStringSync().trim();
  }

  // deletes a generated menu by the menu name
  void deleteGeneratedMenu(String name) {
    Process.runSync('rm', ['-r', 'menu/generated/' + name]);
  }

  // check for directories and necessary files
  void checkDirectoriesFiles() {
    List<String> directories = [
      'menu/templates',
      'menu/generated',
      'menu/data'
    ];
    List<String> files = ['menu/config.json'];

    for (var directory in directories) {
      if (!Directory(directory).existsSync()) {
        Directory(directory).createSync(recursive: true);
      }
    }

    for (var file in files) {
      if (!File(file).existsSync()) {
        File(file).createSync(recursive: true);
      }
    }
  }
}
