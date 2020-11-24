import 'package:dart_console/dart_console.dart';

import 'commands.dart';
import 'generate_command.dart';
import '../helper_classes/helper_classes.dart';

class Controller {
  Console console;
  ConsoleColor highlightColor;
  Fetcher fetcher;

  List<Command> commandList = [];

  Command helpCommand;
  Command updateCommand;
  Command generateCommand;
  Command cleanCommand;

  Controller(console, highlightColor, fetcher) {
    this.console = console;
    this.highlightColor = highlightColor;
    this.fetcher = fetcher;

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
  void launch(int index) async {
    commandList[index].setMap({'commandList': commandList, 'fetcher': fetcher});
    await commandList[index].exec();
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

  // returns the options
  List<String> getOptions() {
    List<String> titleList = [];

    commandList.forEach((element) {
      titleList.add(element.name);
    });

    titleList.add('EXIT');

    return titleList;
  }
}
