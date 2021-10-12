import 'package:dart_console/dart_console.dart';

import '../commands/command.dart';
import '../commands/commands.dart';

class Controller {
  Console? console;
  ConsoleColor? highlightColor;

  List<Command?> commandList = [];

  Command? helpCommand;
  Command? generateCommand;
  Command? cleanCommand;

  Controller(console, highlightColor) {
    this.console = console;
    this.highlightColor = highlightColor;

    helpCommand = new HelpCommand(this.console, this.highlightColor);
    generateCommand = new GenerateCommand(this.console, this.highlightColor);
    cleanCommand = new CleanCommand(this.console, this.highlightColor);

    commandList.add(helpCommand);
    commandList.add(generateCommand);
    commandList.add(cleanCommand);
  }

  // launches a new command
  Future<void> launch(int index) async {
    console!.setForegroundColor(this.highlightColor!);
    console!.writeLine('Launching: ' + commandList[index]!.name!);
    console!.resetColorAttributes();
    console!.writeLine();

    commandList[index]!.setMap({'commandList': commandList});
    commandList[index]!.exec();
  }

  // returns the options
  List<String?> getOptions() {
    List<String?> titleList = [];

    commandList.forEach((element) {
      titleList.add(element!.name);
    });

    titleList.add('EXIT');

    return titleList;
  }
}
