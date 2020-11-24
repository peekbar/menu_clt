import 'package:cli_menu/cli_menu.dart';
import 'package:dart_console/dart_console.dart';

import 'command.dart';

import '../helper_classes/helper_classes.dart';

class UpdateCommand extends Command {
  String shortcut = 'u';
  String name = 'update';
  String definition = 'updates all the existing menus';
  Map<dynamic, dynamic> map;
  LocalFileHelper lfHelper = LocalFileHelper();
  TemplatingHelper tempHelper = TemplatingHelper();

  UpdateCommand(console, ConsoleColor highlightColor)
      : super(console, highlightColor);

  void setMap(Map<dynamic, dynamic> map) {
    this.map = map;
  }

  void exec() async {
    Fetcher fetcher = map['fetcher'];

    List<String> availableMenus = await fetcher.getAvailableMenus();
    List<String> localMenus = lfHelper.getLocalMenuNames();

    if (availableMenus == null) {
      console.writeLine('The database is not responding.');
      return;
    }

    console.writeLine('Please choose, which menus should be updated.');

    List<String> options = [];
    options.add('Update all.');
    options.addAll(localMenus);
    options.add('<- MAIN MENU');
    final menu = Menu(options);
    final result = menu.choose();

    console.clearScreen();

    if (result.index == options.length - 1) {
      return;
    }

    if (result.index == 0) {
      map['argument'] = null;
      console.setForegroundColor(this.highlightColor);
      console.writeLine('Updating all menus to a new version.');
      console.resetColorAttributes();

      for (String name in availableMenus) {
        if (localMenus.contains(name)) {
          var context = await fetcher.getContext(name);
          lfHelper.copyAllFilesTo(name);
          tempHelper.editIndex(name, context);
          tempHelper.editManifest(name, context);
        } else {
          console.writeLine(
              name + ' is not available locally, so it won\'t be updated.');
        }
      }

      console.writeLine('Done.');
    } else {
      console.setForegroundColor(this.highlightColor);
      console.writeLine(
          'Only updating \'' + options[result.index] + '\' to a new version.');
      console.resetColorAttributes();

      var name = options[result.index];

      var context = await fetcher.getContext(name);
      lfHelper.copyAllFilesTo(name);
      tempHelper.editIndex(name, context);
      tempHelper.editManifest(name, context);

      console.writeLine('Done.');
    }
  }
}
