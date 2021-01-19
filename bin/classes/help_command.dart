import 'package:dart_console/dart_console.dart';

import 'command.dart';

class HelpCommand extends Command {
  String shortcut = 'h';
  String name = 'Help';
  String definition = 'prints useful information';
  Map<dynamic, dynamic> map;

  HelpCommand(Console console, ConsoleColor highlightColor)
      : super(console, highlightColor);

  void setMap(Map<dynamic, dynamic> map) {
    this.map = map;
  }

  void exec() async {
    console.writeLine('Welcome to the help center.');
    console.writeLine('Available commands:');

    for (Command command in map['commandList']) {
      console.write(' - ');
      console.setForegroundColor(this.highlightColor);
      console.write(command.name);
      console.resetColorAttributes();
      console.writeLine(': ' + command.definition);
    }
  }
}
