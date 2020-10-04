import 'dart:async';
import 'dart:io';

import 'package:dart_console/dart_console.dart';

import 'package:liquid_engine/liquid_engine.dart';

import '../models/models.dart';
import 'database_helper.dart';
import 'command.dart';

class UpdateCommand extends Command {
  String shortcut = 'u';
  String name = 'update';
  String definition = 'updates all the existing menus';
  Map<dynamic, dynamic> map;
  DatabaseHelper dbHelper = DatabaseHelper();

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
      await copyAllFilesTo(menu);
      await addIndex(menu);
      await addWebmanifest(menu);
    }
  }

  // add all the files to the new directory (delete before copying)
  void copyAllFilesTo(Menu menu) async {
    var directory = await new Directory('menus/' + menu.menuName);

    if (await directory.exists()) {
      await directory.deleteSync(recursive: true);
    }

    await directory.create(recursive: true);

    await Process.runSync('cp', ['-r', 'web', 'menus/web']);
    await new Directory('menus/web').rename('menus/' + menu.menuName);
  }

  // adds all the information to the index.html and writes it in the menu directory
  void addIndex(Menu menu) async {
    var index;

    await new File('menus/' + menu.menuName + '/index.html')
        .readAsString()
        .then((String contents) {
      final context = Context.create();

      context.variables.addAll({
        'page': {
          'homepage': menu.imprint.homepage,
          'phone': menu.imprint.phone,
          'companyName': menu.imprint.companyName
        }
      });

      menu.getCategoriesContext(context);
      menu.getImprintContext(context);

      final template = Template.parse(context, Source.fromString(contents));
      index = template.render(context);
    });

    await new File('menus/' + menu.menuName + '/index.html')
      ..writeAsString(index);
  }

  // adds all the necessary information to the web manifest and copies it to the right directory
  // always use after copyAllFilesTo()
  void addWebmanifest(Menu menu) async {
    var buffer = StringBuffer();
    buffer.write('{');
    buffer.write('"name": "' + menu.imprint.companyName + '",');
    buffer.write('"short_name": "' + menu.imprint.companyName + '",');
    buffer.write('"start_url": ".",');
    buffer.write('"display": "standalone",');
    buffer.write('"background_color": "#fff",');
    buffer.write('"theme_color": "#fff",');
    buffer.write('"description": "A digital menu made by peekbar."');
    buffer.write('}');

    await new File('menus/' + menu.menuName + '/manifest.webmanifest')
        .create(recursive: true);
    await new File('menus/' + menu.menuName + '/manifest.webmanifest')
        .writeAsString(buffer.toString());
  }
}
