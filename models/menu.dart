import 'package:liquid_engine/liquid_engine.dart';

import 'models.dart';

class Menu {
  int id;
  String menuName;
  String icon;
  List<Category> categories = [];
  Imprint imprint;

  Menu(this.id, this.menuName, this.icon);

  void getCategoriesContext(Context context) {
    List<Map> categoriesList = [];

    for (Category category in categories) {
      categoriesList.add(category.toMap());
    }

    context.variables.addAll({'categories': categoriesList});
  }

  void getImprintContext(Context context) {
    context.variables.addAll({
      'imprint': {'id': imprint.id.toString()}
    });
  }

  String getCategoryNames() {
    var buffer = new StringBuffer();

    for (Category category in categories) {
      buffer.write('\'' + category.name + '\',');
    }

    var categoryNames = buffer.toString();

    return categoryNames.substring(1, categoryNames.length - 2);
  }

  String getAllContent() {
    var products = new StringBuffer();

    for (Category category in categories) {
      products.write('\'');
      products.write(category.getProducts());
      products.write('\'');

      if (category.id != categories.length - 1) {
        products.write(',');
      }
    }

    //products.write(',\'' + imprint.toWeb() + '\'');
    return products.toString();
  }
}
