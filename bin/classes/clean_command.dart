import 'package:dart_console/dart_console.dart';

import 'command.dart';

import 'helper_classes.dart';

class CleanCommand extends Command {
  String shortcut = 'c';
  String name = 'Clean';
  String definition =
      'This command deletes generated menus, which files do not exist in \'data\'.';
  Map<dynamic, dynamic> map;
  LocalFileHelper lfHelper = LocalFileHelper();

  CleanCommand(Console console, ConsoleColor highlightColor)
      : super(console, highlightColor);

  void setMap(Map<dynamic, dynamic> map) {
    this.map = map;
  }

  void exec() async {
    List<String> data = lfHelper.getMenusInData();
    List<String> generated = lfHelper.getMenusInGenerated();

    if (data.isNotEmpty) {
      console.setForegroundColor(this.highlightColor);
      console.writeLine('Cleaning local files.');
      console.resetColorAttributes();

      for (String menu in generated) {
        if (!data.contains(menu)) {
          lfHelper.deleteGeneratedMenu(menu);
        }
      }

      console.writeLine('Done.');
    }
  }
}
