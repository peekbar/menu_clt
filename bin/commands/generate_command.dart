import 'dart:io';

import 'package:cli_menu/cli_menu.dart';
import 'package:dart_console/dart_console.dart';

import '../classes/generator.dart';
import '../classes/local_file_helper.dart';
import 'command.dart';

class GenerateCommand extends Command {
  String shortcut = 'g';
  String name = 'Generate';
  String definition =
      'With this command, you are able to choose a template from menu/templates and data files from menu/data to generate the digital menus. This command will print information, if no template or no data file is available.';
  Map<dynamic, dynamic> map;
  LocalFileHelper lfHelper = LocalFileHelper();

  GenerateCommand(Console console, ConsoleColor highlightColor)
      : super(console, highlightColor);

  void setMap(Map<dynamic, dynamic> map) {
    this.map = map;
  }

  void exec() async {
    Generator generator = Generator(console);

    List<String> data = lfHelper.getMenusInData();
    List<String> templates = lfHelper.getTemplates();

    if (templates.isEmpty) {
      console.writeLine('Please add some templates in menu/templates.');
      console.writeLine(
          'You can visit https://github.com/peekbar/menu for instructions.');
      console.writeLine();
    }

    if (data.isEmpty) {
      console.writeLine('Please add data files in menu/data.');
      console.writeLine(
          'You can visit https://github.com/peekbar/menu for instructions.');
      console.writeLine();
    }

    if (templates.isEmpty || data.isEmpty) {
      return;
    }

    console.writeLine('Please choose, which template you want to use:');

    final templateChooser = Menu(templates);
    final templateResult = templateChooser.choose();

    console.writeLine();

    console.writeLine('Please choose, which menus you want to generate:');

    List<String> options = [];
    options.add('Generate all.');
    options.addAll(data);
    options.add('<- MAIN MENU');
    final menuChooser = Menu(options);
    final menuResult = menuChooser.choose();

    console.clearScreen();

    if (menuResult.index == options.length - 1) {
      return;
    } else if (menuResult.index == 0) {
      console.setForegroundColor(this.highlightColor);
      console.writeLine('Generating all new menus.');
      console.resetColorAttributes();

      for (String name in data) {
        lfHelper.copyAllFilesTo(name, templates[templateResult.index]);
        generator.generate(name);
      }

      console.writeLine('Done.');
    } else {
      console.setForegroundColor(this.highlightColor);
      console
          .writeLine('Only generating \'' + options[menuResult.index] + '\'.');
      console.resetColorAttributes();

      var name = options[menuResult.index];

      lfHelper.copyAllFilesTo(name, templates[templateResult.index]);
      generator.generate(name);

      console.writeLine('Done.');
    }
  }
}
