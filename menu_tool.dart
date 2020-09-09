import 'dart:io';
import 'dart:async';

import 'package:args/args.dart';
import 'package:mysql1/mysql1.dart';

import 'models/models.dart';

void main(List<String> arguments) async {
  var parser = ArgParser();
  var results = parser.parse(arguments);

  if (results.rest.isEmpty) {
    print('Sorry, but you have to add a command.');
    exit(1);
  }

  switch (results.rest[0]) {
    case 't':
    case 'test':
      print('This command is only for testing purposes.');
      // Menu menu = Menu();
      // menu.companyName = 'test';
      // menu.menuName = 'testMenu';
      // await copyAllFilesTo(menu);
      // await addWebmanifest(menu);
      //await addIndex(menu);
      break;
    case 'u':
    case 'upgrade':
      if (results.rest.length > 1) {
        print('Only upgrading \'' +
            results.rest[1].toString() +
            '\' to a new version.');
        await upgrade(await getMenus(results.rest[1].toString()));
        print('The menu should be up to date now.');
      } else {
        print('Upgrading all menus to a new version.');
        await upgrade(await getMenus(null));
        print('All menus in the database should be up to date now.');
        print(
            'Menu is still not here? Check the available menus with the list command.');
      }

      break;
    case 'l':
    case 'list':
      // returns all menus in the database
      print('All the available menus in the database:');

      // prints all menus in the menus/ directory
      print('The menus already generated once:');
      Directory('menus')
          .list(recursive: false, followLinks: false)
          .listen((FileSystemEntity entity) {
        print(entity.path.replaceAll('menus/', ''));
      });
      break;
    case 'h':
    case 'help':
      print('Welcome to the help center.');
      print('Available commands:');
      print(' - test (this command is here for testing purposes)');
      print(' - upgrade (upgrades all menus to a newer version, if available)');
      print(' - upgrade menu_name (upgrades only menu_name to a newer version');
      print(' -   or creates it from the database if it is not yet available,');
      print(' -   please make sure the menu_name is in the right format)');
      print(' - list (lists all the created menus and also the menus in the');
      print('     database)');
      print(' - help (prints help instructions)');
      exit(1);
      break;
    default:
      print('Sorry, but this command is not supported.');
      print('Please use \'help\' for more information about this program.');
      exit(1);
  }
}

// updates the web directory to the newest version from Github
void updateFromGit() {
  // update
}

// get the menu from the database and returns a list of menus
Future<List<Menu>> getMenus(String menuName) async {
  List<Menu> menus = [];

  if (menuName == null || menuName == '') {
    // return all menus
  } else {
    // return only the menu with the menuName
  }

  return menus;
}

void upgrade(List<Menu> menus) async {
  for (Menu menu in menus) {
    copyAllFilesTo(menu);
    addIndex(menu);
    addWebmanifest(menu);
  }
}

// add all the files to the new directory (delete before copying)
void copyAllFilesTo(Menu menu) async {
  var directory = new Directory('menus/' + menu.menuName);

  if (await directory.exists()) {
    await directory.deleteSync(recursive: true);
  }

  await Process.run('cp', ['-r', 'web', 'menus/']);
  await new Directory('menus/web').rename('menus/' + menu.menuName);
}

// adds all the information to the index.html and writes it in the menu directory
void addIndex(Menu menu) async {
  var index;

  new File('web/index.html').readAsString().then((String contents) {
    contents.replaceAll('preekbar:homepage', menu.homepage);
    contents.replaceAll('preekbar:phone', menu.imprint.phone);
    contents.replaceAll('peekbar:title', menu.companyName);
    contents.replaceAll('peekbar:categories', menu.getCategories());
    contents.replaceAll('\'peekbar:products\'', menu.getAllContent());
    index = contents;
  });

  await new File('menus/' + menu.menuName + '/index.html')
    ..create(recursive: true)
    ..writeAsString(index);
}

// adds all the necessary information to the web manifest and copies it to the right directory
// always use after copyAllFilesTo()
void addWebmanifest(Menu menu) async {
  var buffer = StringBuffer();
  buffer.write('{');
  buffer.write('"name": "' + menu.companyName + '",');
  buffer.write('"short_name": "' + menu.companyName + '",');
  buffer.write('"start_url": ".",');
  buffer.write('"display": "standalone",');
  buffer.write('"background_color": "#fff",');
  buffer.write('"theme_color": "#fff",');
  buffer.write('"description": "A digital menu made by peekbar."');
  buffer.write('}');

  await new File('menus/' + menu.menuName + '/manifest.webmanifest')
    ..create(recursive: true)
    ..writeAsString(buffer.toString());
}
