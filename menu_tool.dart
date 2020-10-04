import 'dart:io';

import 'package:dart_console/dart_console.dart';

import 'commands/controller.dart';

ConsoleColor primaryColor = ConsoleColor.brightYellow;
String prompt = '>>> ';

void main(List<String> arguments) async {
  final console = Console();
  final controller = Controller(console, primaryColor);

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
      var trimmed = response.trim();
      var arguments = trimmed.split(' ');

      if (arguments.length == 0 || arguments[0] == '') {
        controller.noCommand();
      } else if (arguments.length > 1) {
        await controller.launch(arguments[0][0], arguments[1]);
      } else {
        await controller.launch(arguments[0][0]);
      }
    }
  }
}
