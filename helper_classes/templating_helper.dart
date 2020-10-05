import 'dart:io';

import 'package:liquid_engine/liquid_engine.dart';

import '../models/models.dart';
import 'helper_classes.dart';

class TemplatingHelper {
  LocalFileHelper lfHelper = LocalFileHelper();

  // templates the index.html file of a menu
  void editIndex(Menu menu) {
    File indexFile = lfHelper.getFile(menu, 'index.html');
    String indexContents = indexFile.readAsStringSync();

    Context context = getFullContext(menu);

    final template = Template.parse(context, Source.fromString(indexContents));

    indexFile.writeAsStringSync(template.render(context));
  }

  // generates the webmanifest file inside a local menu directory
  void addWebmanifest(Menu menu) {
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
    File mFile = lfHelper.getFile(menu, 'manifest.webmanifest');
    mFile.createSync(recursive: true);
    mFile.writeAsStringSync(buffer.toString());
  }

  // returns the full context of a menu
  Context getFullContext(Menu menu) {
    final templatingContext = Context.create();

    templatingContext.variables.addAll({
      'page': {
        'homepage': menu.imprint.homepage,
        'phone': menu.imprint.phone,
        'companyName': menu.imprint.companyName
      }
    });

    menu.getCategoriesContext(templatingContext);
    menu.getImprintContext(templatingContext);

    return templatingContext;
  }
}
