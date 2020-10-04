import 'package:mysql1/mysql1.dart';

import '../models/models.dart';

class DatabaseHelper {
  var settings = new ConnectionSettings(
      host: '178.27.74.41',
      port: 3306,
      user: 'generator',
      password: 'Password',
      db: 'menus');

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
}
