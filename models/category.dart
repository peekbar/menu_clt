import 'models.dart';

class Category {
  int id;
  String name;
  String icon;
  List<Product> products;

  String toWeb() {
    var buffer = new StringBuffer();
    buffer.write('<div onclick="selectNew(');
    buffer.write(id.toString());
    buffer.write(')" class="category selected" id="');
    buffer.write(id.toString());
    buffer.write('"><img class="categoryIcon" src="');
    buffer.write(icon);
    buffer.write('" alt="category icon"><p>');
    buffer.write(name);
    buffer.write(
        '</p><img class="arrow" src="core_icons/arrow_right.svg" alt="go to arrow"></div>');
    return buffer.toString();
  }
}
