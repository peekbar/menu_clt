import 'package:dart_console/dart_console.dart';

class Command {
  String shortcut;
  String name;
  String definition;
  Map<dynamic, dynamic> map;

  Console console;
  ConsoleColor highlightColor;

  Command(this.console, this.highlightColor);

  void setMap(Map<dynamic, dynamic> map) {
    this.map = map;
  }

  String getHelpText() {
    return ' - ' + this.name + ': ' + definition;
  }

  void exec() {}
}
