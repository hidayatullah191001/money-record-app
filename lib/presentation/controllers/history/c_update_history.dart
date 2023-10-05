import 'dart:convert';

import 'package:get/get.dart';
import 'package:getx_money_record_app/data/models/history.dart';
import 'package:getx_money_record_app/data/source/history_endpoint.dart';
import 'package:intl/intl.dart';

class CUpdateHistory extends GetxController {
  final _loading = false.obs;
  bool get loading => _loading.value;

  RxBool isLoading = false.obs;

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

  init(idUser, date, type) async {
    _loading.value = true;
    update();

    History? history = await HistoryEndpoint.whereDate(idUser, date, type);
    if (history != null) {
      setDate(history.date);
      setType(history.type);
      _items.value = jsonDecode(history.details!);
      count();
    }

    _loading.value = false;
    update();
  }
}
