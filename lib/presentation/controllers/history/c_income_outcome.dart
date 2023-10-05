import 'package:get/get.dart';
import 'package:getx_money_record_app/data/models/history.dart';
import 'package:getx_money_record_app/data/source/history_endpoint.dart';

class CIncomeOutcome extends GetxController {
  final _loading = false.obs;
  bool get loading => _loading.value;
  final _list = <History>[].obs;
  List<History> get list => _list.value;

  getList(idUser, type) async {
    _loading.value = true;
    update();

    _list.value = await HistoryEndpoint.incomeOutcome(idUser, type);
    update();

    _loading.value = false;
    update();
  }

  search(idUser, type, date) async {
    _loading.value = true;
    update();

    _list.value = await HistoryEndpoint.incomeOutcomeSearch(idUser, type, date);
    update();

    _loading.value = false;
    update();
  }
}
