import 'dart:io';

import 'package:dart_console/dart_console.dart';

import 'tool.dart';

ConsoleColor primaryColor = ConsoleColor.brightYellow;
String prompt = '>>> ';

void main(List<String> arguments) async {
  final console = Console();
  final tool = Tool();

  console.clearScreen();

  console.write('Welcome to ');
  console.setForegroundColor(primaryColor);
  console.write('Menu by PEEKBAR');
  console.resetColorAttributes();
  console.writeLine(
      '. This tool helps you to create or update the menus in the database.');

  console.writeLine('');

  console.write('You can get help by typing the ');
  console.setForegroundColor(primaryColor);
  console.write('help');
  console.resetColorAttributes();
  console.writeLine(' command.');
  console.writeLine('Enter a blank line or press Ctrl+C to exit.');

  while (true) {
    console.write(prompt);
    final response = console.readLine(cancelOnBreak: true);
    if (response == null || response.isEmpty) {
      console.setForegroundColor(primaryColor);
      console.writeLine('Goodbye.');
      console.resetColorAttributes();
      exit(0);
    } else {
      var arguments = response.split(' ');
      switch (arguments[0]) {
        case 'u':
        case 'upgrade':
          if (arguments.length > 1) {
            console.setForegroundColor(primaryColor);
            console.writeLine(
                'Only upgrading \'' + arguments[1] + ' to a new version.');
            console.resetColorAttributes();

            await tool.upgrade(await tool.getMenus(arguments[1]));
            console.writeLine('The menu should be up to date now.');
          } else {
            console.setForegroundColor(primaryColor);
            console.writeLine('Upgrading all menus to a new version.');
            console.resetColorAttributes();

            await tool.upgrade(await tool.getMenus(null));
            console.writeLine(
                'All menus from the database should be up to date now.');
          }
          break;
        case 'l':
        case 'list':
          console.setForegroundColor(primaryColor);
          console.writeLine('Listing all the available menus.');
          console.resetColorAttributes();

          console.writeLine('All the available menus in the database:');
          for (String menuName in await tool.getAvailableMenus()) {
            console.writeLine('- ' + menuName);
          }

          console.writeLine('The menus already generated once:');
          if (await Directory('menus').exists()) {
            Directory('menus')
                .list(recursive: false, followLinks: false)
                .listen((FileSystemEntity entity) {
              String fileName = entity.path.replaceAll('menus/', '');
              if (fileName != '.DS_Store') {
                console.writeLine('- ' + fileName);
              }
            });
          } else {
            console.writeLine('There are no generated menus.');
          }
          break;
        case 'h':
        case 'help':
          console.writeLine('Welcome to the help center.');
          console.writeLine('Available commands:');

          console.write(' - ');
          console.setForegroundColor(primaryColor);
          console.write('test');
          console.resetColorAttributes();
          console.writeLine(': this command is here for testing purposes');

          console.write(' - ');
          console.setForegroundColor(primaryColor);
          console.write('upgrade');
          console.resetColorAttributes();
          console.writeLine(
              ': upgrades all menus to a newer version, if available');

          console.write(' - ');
          console.setForegroundColor(primaryColor);
          console.write('upgrade menu_name');
          console.resetColorAttributes();
          console.writeLine(': upgrades only menu_name to a newer version');

          console.write(' - ');
          console.setForegroundColor(primaryColor);
          console.write('list');
          console.resetColorAttributes();
          console.writeLine(
              ': lists all the created menus and also the menus in the database');

          console.write(' - ');
          console.setForegroundColor(primaryColor);
          console.write('help');
          console.resetColorAttributes();
          console.writeLine(': prints these help instructions');
          break;
        default:
          console.writeLine('Sorry, but this command is not supported.');
          console.write('Please use ');
          console.setForegroundColor(primaryColor);
          console.write('help');
          console.resetColorAttributes();
          console
              .writeLine(' for more information about the available commands.');
      }
    }
  }
}
