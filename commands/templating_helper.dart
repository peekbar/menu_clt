import 'dart:io';

import 'package:liquid_engine/liquid_engine.dart';

import '../models/models.dart';

class TemplatingHelper {
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
