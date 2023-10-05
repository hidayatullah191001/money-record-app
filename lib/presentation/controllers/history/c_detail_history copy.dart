import 'dart:convert';

import 'package:get/get.dart';
import 'package:getx_money_record_app/data/models/history.dart';
import 'package:getx_money_record_app/data/source/history_endpoint.dart';
import 'package:intl/intl.dart';

class CDetailHistory extends GetxController {
  final _loading = false.obs;
  bool get loading => _loading.value;

  final _data = History().obs;
  History get data => _data.value;

  getData(idUser, date, type) async {
    _loading.value = true;
    update();
    History? history = await HistoryEndpoint.whereDate(idUser, date, type);
    _data.value = history ?? History();
    update();
    _loading.value = false;
    update();
  }

  // init(idUser, date, type) async {
  //   _loading.value = true;
  //   update();

  //   History? history = await HistoryEndpoint.whereDate(idUser, date, type);
  //   if (history != null) {
  //     setDate(history.date);
  //     setType(history.type);
  //     _items.value = jsonDecode(history.details!);
  //     count();
  //   }

  //   _loading.value = false;
  //   update();
  // }
}
