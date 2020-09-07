import 'dart:io';
import 'dart:async';

import 'package:args/args.dart';
import 'package:mysql1/mysql1.dart';

import 'models/models.dart';
import 'generators/generators.dart';

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
      new Directory('menus/company_name')
          .create(recursive: true)
          .then((Directory directory) {
        print(directory.path);
      });
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
// returns true if the directory was updated to a new version
// returns false if the directory is already up to date
bool updateFromGit(int currentVersion) {
  return true;
}

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
  List<String> products = [];

  // for (Category category in menu.categories) {
  //   var buffer = StringBuffer();
  //   buffer.write(category.getProducts());
  //   if (category.id)
  // }
}
