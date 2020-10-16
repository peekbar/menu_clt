import 'package:dart_console/dart_console.dart';

import 'command.dart';

import '../helper_classes/helper_classes.dart';

class GenerateCommand extends Command {
  String shortcut = 'g';
  String name = 'generate';
  String definition = 'generates new menus';
  Map<dynamic, dynamic> map;
  Fetcher fetcher = Fetcher();
  LocalFileHelper lfHelper = LocalFileHelper();
  TemplatingHelper tempHelper = TemplatingHelper();

  GenerateCommand(Console console, ConsoleColor highlightColor)
      : super(console, highlightColor);

  void setMap(Map<dynamic, dynamic> map) {
    this.map = map;
  }

  void exec() async {
    List<String> availableMenus = await fetcher.getAvailableMenus();
    List<String> localMenus = lfHelper.getLocalMenuNames();

    if (availableMenus == null) {
      console.writeLine('The database is not responding.');
      return;
    }

    if (map['argument'] != null && map['argument' != '']) {
      console.setForegroundColor(this.highlightColor);
      console.writeLine('Only generating \'' + map['argument'] + '.');
      console.resetColorAttributes();

      var name = map['argument'];

      if (!localMenus.contains(name)) {
        var context = await fetcher.getContext(name);
        lfHelper.copyAllFilesTo(name);
        tempHelper.editIndex(name, context);
        tempHelper.editManifest(name, context);
      } else {
        console.writeLine(name + ' was already generated once.');
      }
      console.writeLine('Done.');
    } else {
      map['argument'] = null;
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
    }
  }
}
