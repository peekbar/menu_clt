import 'dart:async';
import 'dart:io';

import 'package:mysql1/mysql1.dart';
import 'package:liquid_engine/liquid_engine.dart';
import 'models/models.dart';

var settings = new ConnectionSettings(
    host: '178.27.74.41',
    port: 3306,
    user: 'generator',
    password: 'Password',
    db: 'menus');

class Tool {
  // updates the web directory to the newest version from Github
  void updateFromGit() {
    // update
  }

  // creates a list of all the menus available in the database
  Future<List<String>> getAvailableMenus() async {
    List<String> menuNames = [];

    var connection = await MySqlConnection.connect(settings);
    var results = await connection.query('select name_Menu from menu');
    for (var row in results) {
      menuNames.add(row[0]);
    }

    await connection.close();

    return menuNames;
  }

  // get the menu from the database and returns a list of menus
  Future<List<Menu>> getMenus(String menuName) async {
    List<String> menuNames = [];
    List<Menu> menus = [];

    if (menuName == null) {
      menuNames = await getAvailableMenus();
    } else {
      var connection = await MySqlConnection.connect(settings);
      var results = await connection
          .query('select name_Menu from menu where name_Menu = ?', [menuName]);
      for (var row in results) {
        menuNames.add(row[0]);
      }

      await connection.close();
    }

    for (String menuName in menuNames) {
      var connection = await MySqlConnection.connect(settings);
      var menu = await connection.query(
          'select id_Menu, name_Menu, icon_Menu, Imprint_id from menu where name_Menu = ?',
          [menuName]);
      var newMenu;

      for (var row in menu) {
        newMenu = Menu(row[0], row[1], row[2]);

        var categories = await connection.query(
            'select name_Category, icon_Category, id_Category from Category where id_Menu = ?',
            [newMenu.id]);
        int counter = 0;
        for (var row in categories) {
          var newCategory = Category(row[2], row[0], row[1]);

          var products = await connection.query(
              'select id_Product, name_Product, shortName_Product, description_Product, price_Product from Product where id_Category = ?',
              [newCategory.id]);
          for (var row in products) {
            List<String> additives = [];
            var ads = await connection.query(
                'SELECT name_Additive FROM menus.Product_has_Additive NATURAL JOIN menus.Additive WHERE id_Product = ?',
                [row[0]]);
            for (var additive in ads) {
              if (additive != null) {
                additives.add(additive[0]);
              }
            }

            newCategory.products.add(new Product(
                row[0], row[1], row[2], row[3], row[4], additives.join(', ')));
          }

          newCategory.id = counter;
          newMenu.categories.add(newCategory);
          counter++;
        }

        var imprint = await connection.query(
            'select name_Imprint, street_Imprint, city_Imprint, phone_Imprint, mail_Imprint, tax_Imprint, homepage_Imprint, companyName_Imprint from imprint where id_Imprint = ?',
            [newMenu.id]);
        for (var row in imprint) {
          newMenu.imprint = Imprint(newMenu.categories.length, row[0], row[1],
              row[2], row[3], row[4], row[5], row[6], row[7]);
        }
      }

      menus.add(newMenu);

      await connection.close();
    }

    print('Created Dart Objects from the Database.');

    return menus;
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
