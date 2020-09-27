class Product {
  int id;
  String shortName;
  String name;
  String description;
  String price;
  List<String> additives;

  Product(this.id, this.name, this.shortName, this.description, this.price, this.additives);

  String toWeb() {
    var buffer = new StringBuffer();
    buffer.write('<div class="product"><table><tr><th>');
    buffer.write(name);
    buffer.write('</th><td class="price">');
    buffer.write(price);
    buffer.write('</td></tr><tr><td>');
    buffer.write(description);
    buffer.write('</td></tr></table></div>');
    return buffer.toString();
  }
}
