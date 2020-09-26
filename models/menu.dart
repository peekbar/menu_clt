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
}
