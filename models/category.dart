import 'models.dart';

class Category {
  int id;
  String name;
  String icon;
  List<Product> products = [];

  Category(this.id, this.name, this.icon);

  Map toMap() {
    return {'name': this.name, 'id': this.id.toString(), 'icon': this.icon};
  }

  String getProducts() {
    var buffer = new StringBuffer();

    for (Product product in products) {
      buffer.write(product.toWeb());
    }

    return buffer.toString();
  }
}
