import 'package:dart_console/dart_console.dart';

import 'command.dart';
import '../models/models.dart';
import '../helper_classes/helper_classes.dart';

class CleanCommand extends Command {
  String shortcut = 'c';
  String name = 'clean';
  String definition = 'deletes menus, which are not in the database';
  Map<dynamic, dynamic> map;
  DatabaseHelper dbHelper = DatabaseHelper();
  LocalFileHelper lfHelper = LocalFileHelper();

  CleanCommand(Console console, ConsoleColor highlightColor)
      : super(console, highlightColor);

  void setMap(Map<dynamic, dynamic> map) {
    this.map = map;
  }

  void exec() async {
    console.setForegroundColor(this.highlightColor);
    console.writeLine('Cleaning local files.');
    console.resetColorAttributes();

    List<Menu> availableMenus = await dbHelper.getMenus(null);
    List<String> availableMenuNames = [];
    for (Menu menu in availableMenus) {
      availableMenuNames.add(menu.menuName);
    }

    List<String> localMenuNames = lfHelper.getLocalMenuNames();

    for (String localMenuName in localMenuNames) {
      if (!availableMenuNames.contains(localMenuName)) {
        lfHelper.deleteLocalMenu(localMenuName);
      }
    }

    console.writeLine('Done.');
  }
}
