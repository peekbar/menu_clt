import 'package:dart_console/dart_console.dart';

import 'command.dart';
import '../models/models.dart';
import '../helper_classes/helper_classes.dart';

class GenerateCommand extends Command {
  String shortcut = 'g';
  String name = 'generate';
  String definition = 'generates new menus';
  Map<dynamic, dynamic> map;
  DatabaseHelper dbHelper = DatabaseHelper();
  LocalFileHelper lfHelper = LocalFileHelper();
  TemplatingHelper tempHelper = TemplatingHelper();

  GenerateCommand(Console console, ConsoleColor highlightColor)
      : super(console, highlightColor);

  void setMap(Map<dynamic, dynamic> map) {
    this.map = map;
  }

  void exec() async {
    if (map['argument'] != null && map['argument' != '']) {
      console.setForegroundColor(this.highlightColor);
      console.writeLine('Only generating \'' + map['argument'] + '.');
      console.resetColorAttributes();
    } else {
      map['argument'] = null;
      console.setForegroundColor(this.highlightColor);
      console.writeLine('Generating all new menus.');
      console.resetColorAttributes();
    }

    List<Menu> availableMenus = await dbHelper.getMenus(map['argument']);
    List<String> localMenus = lfHelper.getLocalMenuNames();

    for (Menu menu in availableMenus) {
      if (!localMenus.contains(menu.menuName)) {
        lfHelper.copyAllFilesTo(menu);
        tempHelper.editIndex(menu);
        tempHelper.addWebmanifest(menu);
      } else {
        console.writeLine(menu.menuName + ' was already generated once.');
      }
    }

    console.writeLine('Done.');
  }
}
