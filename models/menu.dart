import 'models.dart';

class Menu {
  String menuName;
  String companyName;
  String homepage;
  String icon;
  List<Category> categories;
  Imprint imprint;

  Menu(this.menuName, this.companyName, this.homepage, this.icon, this.imprint);

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
