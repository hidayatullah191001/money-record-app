import 'package:get/get.dart';
import 'package:getx_money_record_app/data/models/history.dart';
import 'package:getx_money_record_app/data/source/history_endpoint.dart';

class CHistory extends GetxController {
  final _loading = false.obs;
  bool get loading => _loading.value;
  final _list = <History>[].obs;
  List<History> get list => _list.value;

  getList(idUser) async {
    _loading.value = true;
    update();

    _list.value = await HistoryEndpoint.history(idUser);
    update();

    _loading.value = false;
    update();
  }

  search(idUser, date) async {
    _loading.value = true;
    update();

    _list.value = await HistoryEndpoint.historySearch(idUser, date);
    update();

    _loading.value = false;
    update();
  }
}
