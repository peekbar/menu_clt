class Imprint {
  String name;
  String street;
  String city;
  String phone;
  String mail;
  String taxNumber;

  String toWeb() {
    var buffer = new StringBuffer();
    buffer.write('<table>');
    buffer.write('<th>TODO: Impressum</th>');
    buffer.write('</table>');
    return buffer.toString();
  }
}
