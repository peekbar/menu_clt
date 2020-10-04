import 'package:dart_console/dart_console.dart';

import 'commands.dart';

class Controller {
  Console console;
  ConsoleColor highlightColor;

  List<Command> commandList = [];

  Command helpCommand;
  Command updateCommand;

  Controller(console, highlightColor) {
    this.console = console;
    this.highlightColor = highlightColor;

    helpCommand = new HelpCommand(this.console, this.highlightColor);
    updateCommand = new UpdateCommand(this.console, this.highlightColor);

    commandList.add(helpCommand);
    commandList.add(updateCommand);
  }

  void launch(String shortcut, [String argument]) async {
    var found = false;

    for (Command command in commandList) {
      if (command.shortcut == shortcut) {
        Map map = Map();
        map.addAll({'commandList': commandList});
        if (argument != null) {
          map.addAll({'argument': argument});
        }
        command.setMap(map);
        await command.exec();
        found = true;
        break;
      }
    }

    if (!found) {
      this.noCommand();
    }
  }

  void noCommand() {
    console.writeLine('Sorry, but this command is not supported.');
    console.write('Please use ');
    console.setForegroundColor(this.highlightColor);
    console.write('help');
    console.resetColorAttributes();
    console.writeLine(' for more information about the available commands.');
  }
}
