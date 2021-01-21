import 'dart:convert';
import 'dart:io';

import 'package:dart_console/dart_console.dart';
import 'package:liquid_engine/liquid_engine.dart';

import 'languages.dart';
import 'local_file_helper.dart';

class Generator {
  Console console;

  Generator(this.console);

  // returns the context of a menu
  void generate(String name) {
    try {
      var context = Context.create();
      Map data = jsonDecode(
          LocalFileHelper().getContents(File('menu/data/' + name + '.json')));
      data = addIDs(data);
      data = addSystemTitles(data);
      context.variables = data;
      this.editIndex(name, context);
      this.editManifest(name, context);
    } catch (e) {
      console.writeLine();
      console.writeLine('It seems like something went wrong.');
      console.writeLine();
    }
  }

  // this function adds ids for each category, group and product
  Map addIDs(Map data) {
    var category = 0;
    var group = 0;
    var product = 0;

    for (Map<String, dynamic> c in data["categories"]) {
      c["id"] = category;

      for (Map<String, dynamic> p in c["products"]) {
        p["id"] = product;
        product++;
      }

      category++;
    }

    if (data.containsKey("opening_hours")) {
      data["opening_hours"]["id"] = category;
      category++;
    }

    if (data.containsKey("min_order")) {
      data["min_order"]["id"] = category;
      category++;
    }

    if (data.containsKey("imprint")) {
      data["imprint"]["id"] = category;
      category++;
    }

    return data;
  }

  // this function adds the language specific system titles
  // if no language is given or the given language is not supported, the english language is loaded
  Map addSystemTitles(Map data) {
    String lang;
    List<String> supportedLanguages = Languages().getSupportedLanguages();

    if (data.containsKey("language")) {
      supportedLanguages.contains(data["language"].toUpperCase())
          ? lang = data["language"]
          : lang = "EN";
    } else {
      lang = "EN";
    }

    data["system"] = Languages().getSystemTitles(lang);

    return data;
  }

  // templates the index.html file of a menu
  void editIndex(String name, Context context) {
    File index = File('menu/generated/' + name + '/index.html');
    String contents = LocalFileHelper().getContents(index);
    final template = Template.parse(context, Source.fromString(contents));
    index.writeAsStringSync(template.render(context));
  }

  // templates the index.html file of a menu
  void editManifest(String name, Context context) {
    File manifest = File('menu/generated/' + name + '/manifest.webmanifest');
    String contents = LocalFileHelper().getContents(manifest);
    final template = Template.parse(context, Source.fromString(contents));
    manifest.writeAsStringSync(template.render(context));
  }
}
