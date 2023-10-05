import 'package:get/get.dart';
import 'package:getx_money_record_app/data/source/history_endpoint.dart';
import 'package:intl/intl.dart';

class CAddHistory extends GetxController {
  final _date = DateFormat('yyyy-MM-dd').format(DateTime.now()).obs;
  String get date => _date.value;
  setDate(n) => _date.value = n;

  final _type = 'Pemasukan'.obs;
  String get type => _type.value;
  setType(n) => _type.value = n;

  final _items = [].obs;
  List get items => _items.value;
  addItem(n) {
    _items.value.add(n);
    count();
  }

  deleteItem(i) {
    _items.value.removeAt(i);
    count();
  }

  final _total = 0.0.obs;
  double get total => _total.value;
  setTotal(n) => _total.value = n;

  count() {
    double total = items.map((e) => e['price']).toList().fold(
        0.0,
        (previousValue, element) =>
            double.parse(previousValue.toString()) + double.parse(element));
    setTotal(total);
    update();
  }
}
