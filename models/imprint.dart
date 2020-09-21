class Imprint {
  int id;
  String name;
  String street;
  String city;
  String phone;
  String mail;
  String tax;
  String homepage;
  String companyName;

  Imprint(this.id, this.name, this.street, this.city, this.phone, this.mail,
      this.tax, this.homepage, this.companyName);

  String toWeb() {
    var buffer = new StringBuffer();
    buffer.write('<table>');
    buffer.write('<th>TODO: Impressum</th>');
    buffer.write('</table>');
    return buffer.toString();
  }
}
