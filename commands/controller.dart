import 'package:dart_console/dart_console.dart';

import 'commands.dart';
import 'generate_command.dart';

class Controller {
  Console console;
  ConsoleColor highlightColor;

  List<Command> commandList = [];

  Command helpCommand;
  Command updateCommand;
  Command generateCommand;
  Command cleanCommand;

  Controller(console, highlightColor) {
    this.console = console;
    this.highlightColor = highlightColor;

    helpCommand = new HelpCommand(this.console, this.highlightColor);
    updateCommand = new UpdateCommand(this.console, this.highlightColor);
    generateCommand = new GenerateCommand(this.console, this.highlightColor);
    cleanCommand = new CleanCommand(this.console, this.highlightColor);

    commandList.add(helpCommand);
    commandList.add(updateCommand);
    commandList.add(generateCommand);
    commandList.add(cleanCommand);
  }

  // launches a new command
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

  // prints help if no command was found
  void noCommand() {
    console.writeLine('Sorry, but this command is not supported.');
    console.write('Please use ');
    console.setForegroundColor(this.highlightColor);
    console.write('help');
    console.resetColorAttributes();
    console.writeLine(' for more information about the available commands.');
  }
}
