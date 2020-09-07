import 'dart:io';
import 'dart:async';

import 'package:args/args.dart';

import 'package:mysql1/mysql1.dart';

void main(List<String> arguments) async {
  exitCode = 0; // presume success

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
      exit(1);
      break;
    default:
      print('Sorry, but this command is not supported.');
      print('Please use \'help\' for more information about this program.');
      exit(1);
  }
}
