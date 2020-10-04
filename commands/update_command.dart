import 'package:dart_console/dart_console.dart';

import 'command.dart';
import '../models/models.dart';
import '../helper_classes/helper_classes.dart';

class UpdateCommand extends Command {
  String shortcut = 'u';
  String name = 'update';
  String definition = 'updates all the existing menus';
  Map<dynamic, dynamic> map;
  DatabaseHelper dbHelper = DatabaseHelper();
  LocalFileHelper lfHelper = LocalFileHelper();
  TemplatingHelper tempHelper = TemplatingHelper();

  UpdateCommand(Console console, ConsoleColor highlightColor)
      : super(console, highlightColor);

  void setMap(Map<dynamic, dynamic> map) {
    this.map = map;
  }

  void exec() async {
    if (map['argument'] != null && map['argument' != '']) {
      console.setForegroundColor(this.highlightColor);
      console.writeLine(
          'Only updating \'' + map['argument'] + ' to a new version.');
      console.resetColorAttributes();
    } else {
      map['argument'] = null;
      console.setForegroundColor(this.highlightColor);
      console.writeLine('Updating all menus to a new version.');
      console.resetColorAttributes();
    }

    await upgrade(await dbHelper.getMenus(map['argument']));

    console.writeLine('Done.');
  }

  void upgrade(List<Menu> menus) async {
    for (Menu menu in menus) {
      await lfHelper.copyAllFilesTo(menu);
      await tempHelper.addIndex(menu);
      await tempHelper.addWebmanifest(menu);
    }
  }
}
