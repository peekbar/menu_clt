import 'models.dart';

class Menu {
  String version;
  String menuName;
  String companyName;
  String icon;
  List<Category> categories;
  Imprint imprint;

  String getCategories() {
    var buffer = new StringBuffer();

    for (Category category in categories) {
      buffer.write(category.toWeb());
    }

    return buffer.toString();
  }
}
