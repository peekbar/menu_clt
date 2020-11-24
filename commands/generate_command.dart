import 'package:cli_menu/cli_menu.dart';
import 'package:dart_console/dart_console.dart';

import 'command.dart';

import '../helper_classes/helper_classes.dart';

class GenerateCommand extends Command {
  String shortcut = 'g';
  String name = 'Generate';
  String definition = 'generates new menus';
  Map<dynamic, dynamic> map;
  LocalFileHelper lfHelper = LocalFileHelper();
  TemplatingHelper tempHelper = TemplatingHelper();

  GenerateCommand(Console console, ConsoleColor highlightColor)
      : super(console, highlightColor);

  void setMap(Map<dynamic, dynamic> map) {
    this.map = map;
  }

  void exec() async {
    Fetcher fetcher = map['fetcher'];

    List<String> availableMenus = await fetcher.getAvailableMenus();
    List<String> localMenus = lfHelper.getLocalMenuNames();

    if (availableMenus == null) {
      return;
    }

    console.writeLine('Please choose, which menus should be generated.');

    List<String> options = [];
    options.add('Generate all.');
    options.addAll(availableMenus);
    options.add('<- MAIN MENU');
    final menu = Menu(options);
    final result = menu.choose();

    console.clearScreen();

    if (result.index == options.length - 1) {
      return;
    }

    if (result.index == 0) {
      console.setForegroundColor(this.highlightColor);
      console.writeLine('Generating all new menus.');
      console.resetColorAttributes();

      for (String name in availableMenus) {
        if (!localMenus.contains(name)) {
          var context = await fetcher.getContext(name);
          lfHelper.copyAllFilesTo(name);
          tempHelper.editIndex(name, context);
          tempHelper.editManifest(name, context);
        } else {
          console.writeLine(name + ' was already generated once.');
        }
      }

      console.writeLine('Done.');
    } else {
      console.setForegroundColor(this.highlightColor);
      console.writeLine('Only generating \'' + options[result.index] + '\'.');
      console.resetColorAttributes();

      var name = options[result.index];

      if (!localMenus.contains(name)) {
        var context = await fetcher.getContext(name);
        lfHelper.copyAllFilesTo(name);
        tempHelper.editIndex(name, context);
        tempHelper.editManifest(name, context);
      } else {
        console.writeLine(name + ' was already generated once.');
      }

      console.writeLine('Done.');
    }
  }
}
