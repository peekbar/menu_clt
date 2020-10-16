import 'dart:async';

import 'package:liquid_engine/liquid_engine.dart';
import 'package:postgres/postgres.dart';

class Fetcher {
  var connection = PostgreSQLConnection("localhost", 5432, "dart_test",
      username: "dart", password: "dart");

  // returns a list of all the menu names in the database
  Future<List<String>> getAvailableMenus() async {
    List<String> menuNames = [];

    try {
      await connection.open();

      List<List<dynamic>> results =
          await connection.query('SELECT name_Menu FROM menu');

      for (var row in results) {
        menuNames.add(row[0]);
      }

      await connection.close();
    } catch (e) {
      return null;
    }

    return menuNames;
  }

  // returns the context of a menu
  Future<Context> getContext(String menuName) async {
    Context context = Context.create();
    await connection.open();

    List<List<dynamic>> menu = await connection.query(
        'SELECT id_Menu, name_Menu, icon_Menu, Imprint_id FROM menu WHERE name_Menu = @name',
        substitutionValues: {'name': menuName});

    for (var row in menu) {
      var menuId = row[0];
      var imprintId = row[3];
      int counter = 0;
      List<Map> categoriesList = [];

      List<List<dynamic>> categories = await connection.query(
          'SELECT id_Category, name_Category, icon_Category FROM Category WHERE id_Menu = @menuId',
          substitutionValues: {'menuId': menuId});

      for (var row in categories) {
        var categoryId = row[0];
        List<Map> productsList = [];

        List<List<dynamic>> products = await connection.query(
            'SELECT id_Product, name_Product, shortName_Product, description_Product, price_Product FROM Product WHERE id_Category = @categoryId',
            substitutionValues: {'categoryId': categoryId});

        for (var row in products) {
          var productId = row[0];
          List<String> additivesList = [];

          List<List<dynamic>> ads = await connection.query(
              'SELECT name_Additive FROM menus.Product_has_Additive NATURAL JOIN menus.Additive WHERE id_Product = @productId',
              substitutionValues: {'productId': productId});

          for (var additive in ads) {
            if (additive != null) {
              additivesList.add(additive[0]);
            }
          }

          productsList.add({
            'id': counter,
            'name': row[1],
            'additives': additivesList.join(', '),
          });
        }

        categoriesList.add({
          'id': categoryId,
          'name': row[1],
          'icon': row[2],
          'products': productsList,
        });

        counter++;
      }

      context.variables.addAll({'categories': categoriesList});

      List<List<dynamic>> imprint = await connection.query(
          'SELECT name_Imprint, street_Imprint, city_Imprint, phone_Imprint, mail_Imprint, tax_Imprint, homepage_Imprint, companyName_Imprint FROM imprint WHERE id_Imprint = @imprintId',
          substitutionValues: {'imprintId': imprintId});

      for (var row in imprint) {
        context.variables.addAll({
          'imprint': {
            'id': counter,
            'name': row[0],
            'street': row[1],
            'city': row[2],
            'phone': row[3],
            'mail': row[4],
            'tax': row[5],
            'homepage': row[6],
            'companyName': row[7],
          }
        });
      }
    }

    await connection.close();
    return context;
  }
}
