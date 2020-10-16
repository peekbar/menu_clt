import 'dart:io';

import 'package:liquid_engine/liquid_engine.dart';

import 'helper_classes.dart';

class TemplatingHelper {
  LocalFileHelper lfHelper = LocalFileHelper();

  // templates the index.html file of a menu
  void editIndex(String name, Context context) {
    File indexFile = lfHelper.getFile(name, 'index.html');
    String indexContents = indexFile.readAsStringSync();

    final template = Template.parse(context, Source.fromString(indexContents));

    indexFile.writeAsStringSync(template.render(context));
  }

  // templates the index.html file of a menu
  void editManifest(String name, Context context) {
    File indexFile = lfHelper.getFile(name, 'manifest.webmanifest');
    String indexContents = indexFile.readAsStringSync();

    final template = Template.parse(context, Source.fromString(indexContents));

    indexFile.writeAsStringSync(template.render(context));
  }
}
