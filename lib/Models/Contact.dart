import 'package:safe/Utils/dart/database_helper.dart';

class Contact {
  static const tblContact = 'contacts';
  static const colId = 'id';
  static const colName = 'name';
  static const colAmount = 'amount';
  static const colMobile = 'mobile';

  Contact.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    name = map[colName];
    amount = map[colAmount];
    mobile = map[colMobile];
  }

  int id;
  String name;
  String amount;
  String mobile;

  Contact({this.id, this.name, this.amount, this.mobile,});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colName: name,
      colAmount: amount,
      colMobile: mobile,
    };
    if (id != null)
      map[colId] = id;
      return map;
  }
}
