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

    for (Category category in categories) {
      buffer.write(category.toWeb());
    }

    buffer.write('<div onclick="selectNew(');
    buffer.write(categories.length.toString());
    buffer.write(')" class="link" id="');
    buffer.write(categories.length.toString());
    buffer.write('"><p>Impressum</p></div>');

    var aboutId = categories.length + 1;

    buffer.write('<div onclick="selectNew(');
    buffer.write(aboutId.toString());
    buffer.write(')" class="link" id="');
    buffer.write(aboutId.toString());
    buffer.write('"><p>Über diese Seite</p></div>');

    return buffer.toString();
  }

  String getCategoryNames() {
    var buffer = new StringBuffer();

    for (Category category in categories) {
      buffer.write('\'' + category.name + '\',');
    }

    var categoryNames = buffer.toString();

    return categoryNames.substring(0, categoryNames.length - 1);
  }

  String getAllContent() {
    var products = new StringBuffer();

    var i = categories.length;
    for (Category category in categories) {
      i--;
      products.write(category.getProducts());
      if (i != 0) {
        products.write(',');
      }
    }

    products.write(',' + imprint.toWeb());
    return products.toString();
  }
}
