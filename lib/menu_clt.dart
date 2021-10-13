import 'dart:io';

import 'package:cli_menu/cli_menu.dart';
import 'package:dart_console/dart_console.dart';

import 'classes/controller.dart';
import 'classes/local_file_helper.dart';

ConsoleColor primaryColor = ConsoleColor.brightYellow;
String prompt = '>>> ';

void main(List<String> arguments) async {
  final console = Console();

  console.clearScreen();
  console.hideCursor();

  console.write('Welcome to \'');
  console.setForegroundColor(primaryColor);
  console.write('menu by PEEKBAR');
  console.resetColorAttributes();
  console.writeLine(
      '\'. This tool helps you to create digital menus from json files and templates.');
  console.writeLine();
  console.writeLine(
      'You can select options in the menu with the arrow keys and ENTER.');
  console.write(
      'For more information on how to use this program, please choose the ');
  console.setForegroundColor(primaryColor);
  console.write('help');
  console.resetColorAttributes();
  console.writeLine(' option.');
  console.writeLine('Please choose EXIT to quit the program.');

  console.writeLine();

  final controller = Controller(console, primaryColor);
  LocalFileHelper().checkDirectoriesFiles();

  while (true) {
    console.writeLine('-----------------------------');
    console.setForegroundColor(primaryColor);
    console.writeLine('MAIN MENU');
    console.resetColorAttributes();
    console.writeLine('-----------------------------');
    console.writeLine('Please choose:');

    List<String?> options = controller.getOptions();
    final menu = Menu(options);
    final result = menu.choose();

    if (result.index == options.length - 1) {
      console.clearScreen();
      console.setForegroundColor(primaryColor);
      console.writeLine('Goodbye.');
      console.showCursor();

      exit(0);
    } else {
      console.clearScreen();
      await controller.launch(result.index);
    }
  }
}
