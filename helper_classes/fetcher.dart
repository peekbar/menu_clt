import 'dart:async';

import 'package:liquid_engine/liquid_engine.dart';
import 'package:postgres/postgres.dart';

class Fetcher {
  var connection = PostgreSQLConnection("192.168.1.5", 5432, "menu",
      username: "generator", password: "Password");

  void openConnection() async {
    await connection.open();
  }

  void closeConnection() async {
    await connection.close();
  }

  // returns a list of all the menu names in the database
  Future<List<String>> getAvailableMenus() async {
    List<String> menuNames = [];

    try {
      List<List<dynamic>> results =
          await connection.query('SELECT name FROM "Menu"');

      for (var row in results) {
        menuNames.add(row[0]);
      }
    } catch (e) {
      return null;
    }

    return menuNames;
  }

  // returns the context of a menu
  Future<Context> getContext(String menuName) async {
    Context context = Context.create();

    try {
      List<List<dynamic>> menu = await connection.query(
          'SELECT id, icon, "Imprint_id" FROM "Menu" WHERE name = @name',
          substitutionValues: {'name': menuName});

      for (var row in menu) {
        var menuId = row[0];
        var imprintId = row[2];
        List<Map> categoriesList = [];

        List<List<dynamic>> categories = await connection.query(
            'SELECT id, name, icon, position FROM "Category" WHERE "Menu_id" = @menuId',
            substitutionValues: {'menuId': menuId});

        var counter = 0;

        for (var row in categories) {
          var categoryId = row[0];
          List<Map> productsList = [];

          List<List<dynamic>> products = await connection.query(
              'SELECT id, name, shortname, description, price, position FROM "Product" WHERE "Category_id" = @categoryId',
              substitutionValues: {'categoryId': categoryId});

          bool first = true;

          for (var row in products) {
            var productId = row[0];
            List<String> additivesList = [];

            // List<List<dynamic>> ads = await connection.query(
            //     'SELECT name_Additive FROM menus.Product_has_Additive NATURAL JOIN menus.Additive WHERE Product_id = @productId',
            //     substitutionValues: {'productId': productId});

            // for (var additive in ads) {
            //   if (additive != null) {
            //     additivesList.add(additive[0]);
            //   }
            // }

            productsList.add({
              'id': productId,
              'name': row[1],
              'shortname': row[2],
              'description': row[3],
              'price': row[4],
              'position': row[5],
              'additives': additivesList.join(', '),
              'first': first,
            });
            first = false;
          }

          categoriesList.add({
            'id': counter,
            'name': row[1],
            'icon': row[2],
            'position': row[3],
            'products': productsList,
          });

          counter++;
        }

        context.variables.addAll({'categories': categoriesList});

        List<List<dynamic>> imprint = await connection.query(
            'SELECT id, holder, street, city, phone, mail, tax, homepage, companyname FROM "Imprint" WHERE id = @imprintId',
            substitutionValues: {'imprintId': imprintId});

        for (var row in imprint) {
          context.variables.addAll({
            'imprint': {
              'id': counter,
              'holder': row[1],
              'street': row[2],
              'city': row[3],
              'phone': row[4],
              'mail': row[5],
              'tax': row[6],
              'homepage': row[7],
              'companyname': row[8],
            }
          });
        }
      }
    } catch (e) {
      print('something is wrong');
    }

    return context;
  }
}
