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
    case 'i':
    case 'init':
      print('init');
      Menu menu = Menu();
      menu.companyName = 'test';
      menu.menuName = 'testMenu';
      await addWebmanifest('', menu);
      // if argument init: init this program
      // create database: don't do this when there is a database in database dir
      // don't run upgade as the database is empty
      break;
    case 'u':
    case 'upgrade':
      if (results.rest.length > 1) {
        print('Only upgrading \'' +
            results.rest[1].toString() +
            '\' to a new version.');
        // if argument upgrade _company_name_: check for of the menu
        // compare info.json from web dir with info.json from menus/_company_name_ dir
        // if dir is not there: new company
        // create new if necessary and then deploy
      } else {
        print('Upgrading all menus to a new version.');
        // if argument upgrade: get new web from github
        // save the version of /web/info.json
        // remove the web folder
        // dowload the new web folder from git
        // if the version is the same: do nothing
        // if version is different: run over all menus in the database
        // create new dir for new menus if necessary
        // deploy them to the server
      }
      break;
    case 'l':
    case 'list':
      // returns all menus in the menus/ folder
      // returns all menus in the database
      break;
    case 'h':
    case 'help':
      print('Welcome to the help center.');
      print('Available commands:');
      print(' - init (initialize the program)');
      print(' - upgrade (upgrades all menus to a newer version, if available)');
      print(' - upgrade menu_name (upgrades only menu_name to a newer version');
      print(' -   or creates it from the database if it is not yet available,');
      print(' -   please make sure the menu_name is in the right format)');
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
List<Menu> getMenus(String menuName) {
  List<Menu> menus = [];

  if (menuName == null || menuName == '') {
    // return all menus
  } else {
    // return only the menu with the menuName
  }

  return menus;
}

// creates a menu from the database and returns it
void generateWeb(Menu menu) {
  String categories = menu.getCategories();
  var products = new StringBuffer();

  var i = menu.categories.length;
  for (Category category in menu.categories) {
    i--;
    products.write(category.getProducts());
    if (i != 0) {
      products.write(',');
    }
  }

  products.write(',' + menu.imprint.toWeb());

  addToIndex('menus/' + menu.menuName + '/index.html', menu.companyName,
      categories, products.toString());
  addWebmanifest('menus/' + menu.menuName + '/manifest.webmanifest', menu);
}

// add all the files to the new directory (delete before copying)
void copyAllFilesTo(String path) {
  final dir = Directory(path);
  dir.deleteSync(recursive: true);

  new Directory('menus/company_name')
      .create(recursive: true)
      .then((Directory directory) {
    print(directory.path);
  });
  // copy /web directory to the path
}

// adds all the information to the index.html
void addToIndex(
    String path, String companyName, String categories, String products) {
  // load in menu_name/index.html
  // add the companyName to peekbar:title
  // add the categories to peekbar:categories
  // add the products to 'peekbar:products'
}

// adds all the necessary information to the web manifest
void addWebmanifest(String path, Menu menu) async {
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

  var file = await new File('menus/' + menu.menuName + '/manifest.webmanifest')
      .create(recursive: true);
  file.writeAsString(buffer.toString());
}
