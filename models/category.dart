import 'models.dart';

class Category {
  int id;
  String name;
  String icon;
  List<Product> products = [];

  Category(this.id, this.name, this.icon);

  Map toMap() {
    List productList = [];
    for (Product product in products) {
      productList.add({
        'id': product.id.toString(),
        'shortName': product.shortName,
        'name': product.name,
        'description': product.description,
        'price': product.price
      });
    }

    return {
      'name': this.name,
      'id': this.id.toString(),
      'icon': this.icon,
      'products': productList
    };
  }

  String getProducts() {
    var buffer = new StringBuffer();

    for (Product product in products) {
      buffer.write(product.toWeb());
    }

    return buffer.toString();
  }
}
