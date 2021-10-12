import 'package:dart_console/dart_console.dart';

import 'command.dart';

class HelpCommand extends Command {
  String? shortcut = 'h';
  String? name = 'Help';
  String? definition =
      'The help command prints general information about the use of this software package. It also prints a list with all the available commands.';
  Map<dynamic, dynamic>? map;

  HelpCommand(Console? console, ConsoleColor? highlightColor)
      : super(console, highlightColor);

  void setMap(Map<dynamic, dynamic> map) {
    this.map = map;
  }

  void exec() async {
    console!.writeLine('Welcome to the help center.');
    console!.writeLine();
    console!.writeLine(
        'For general information about this software package, please visit https://github.com/peekbar/menu for instructions.');
    console!.writeLine();
    console!.writeLine('Available commands:');

    for (Command command in map!['commandList']) {
      console!.write(' - ');
      console!.setForegroundColor(this.highlightColor!);
      console!.write(command.name!);
      console!.resetColorAttributes();
      console!.writeLine(': ' + command.definition!);
    }
  }
}
