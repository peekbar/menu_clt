import 'dart:io';

import 'package:cli_menu/cli_menu.dart';
import 'package:dart_console/dart_console.dart';

import 'commands/controller.dart';
import 'helper_classes/fetcher.dart';

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
      '\'. This tool helps you to create or update the menus from the database.');

  console.writeLine('');

  console.write('You can get help by choosing the ');
  console.setForegroundColor(primaryColor);
  console.write('help');
  console.resetColorAttributes();
  console.writeLine(' option.');
  console.writeLine('Please choose EXIT to quit the program.');

  final fetcher = Fetcher(console);
  final controller = Controller(console, primaryColor, fetcher);
  await fetcher.openConnection();

  while (true) {
    console.writeLine('-----------------------------');
    console.setForegroundColor(primaryColor);
    console.writeLine('MAIN MENU');
    console.resetColorAttributes();
    console.writeLine('-----------------------------');
    console.writeLine('Please choose:');

    List<String> options = controller.getOptions();
    final menu = Menu(options);
    final result = menu.choose();

    if (result.index == options.length - 1) {
      console.clearScreen();
      console.setForegroundColor(primaryColor);
      console.writeLine('Goodbye.');
      console.showCursor();

      await fetcher.closeConnection();

      exit(0);
    } else {
      console.clearScreen();
      await controller.launch(result.index);
    }
  }
}
