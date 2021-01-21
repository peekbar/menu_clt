import 'package:dart_console/dart_console.dart';

import '../classes/local_file_helper.dart';
import 'command.dart';

class CleanCommand extends Command {
  String shortcut = 'c';
  String name = 'Clean';
  String definition =
      'This command deletes generated menus, which files do not exist in \'menu/data\'. You can use this option to delete generated menus, which you do not need anymore.';
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

    if (generated.isNotEmpty) {
      console.writeLine('Cleaning local files.');

      for (String menu in generated) {
        if (!data.contains(menu)) {
          lfHelper.deleteGeneratedMenu(menu);
        }
      }

      console.writeLine('Done.');
    } else {
      console.writeLine('There are no files to clean.');
    }
  }
}
