import 'models.dart';

class Menu {
  int id;
  String menuName;
  String icon;
  List<Category> categories = [];
  Imprint imprint;

  Menu(this.id, this.menuName, this.icon);

  String getCategories() {
    var buffer = new StringBuffer();
    var position = 0;

    for (Category category in categories) {
      buffer.write(category.toWeb(position));
      position++;
    }

    buffer.write('<div onclick="selectNew(');
    buffer.write(position.toString());
    buffer.write(')" class="link" id="');
    buffer.write(position.toString());
    buffer.write('"><p>Impressum</p></div>');

    return buffer.toString();
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

    var i = categories.length;
    for (Category category in categories) {
      i--;
      products.write('\'');
      products.write(category.getProducts());
      products.write('\'');
      if (i != 0) {
        products.write(',');
      }
    }

    products.write(',\'' + imprint.toWeb() + '\'');
    return products.toString();
  }
}
