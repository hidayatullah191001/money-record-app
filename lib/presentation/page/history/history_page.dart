import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_money_record_app/config/app_color.dart';
import 'package:getx_money_record_app/config/app_format.dart';
import 'package:getx_money_record_app/data/models/history.dart';
import 'package:getx_money_record_app/data/source/history_endpoint.dart';
import 'package:getx_money_record_app/presentation/controllers/c_user.dart';
import 'package:getx_money_record_app/presentation/controllers/history/c_history.dart';
import 'package:getx_money_record_app/presentation/controllers/history/c_income_outcome.dart';
import 'package:getx_money_record_app/presentation/page/history/detail_history_page.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPagePageState();
}

class _HistoryPagePageState extends State<HistoryPage> {
  final cHistory = Get.put(CHistory());
  final cUser = Get.put(CUser());
  final searchController = TextEditingController();

  refresh() {
    cHistory.getList(cUser.data.idUser!);
  }

  delete(String idHistory) {
    Get.defaultDialog(
      title: 'Hapus history',
      content: const Text('Yakin ingin menghapus data?'),
      textConfirm: 'Hapus',
      textCancel: 'Batal',
      onConfirm: () async {
        bool success = await HistoryEndpoint.deleteHistory(idHistory);
        if (success) refresh();
        Get.back();
      },
      confirmTextColor: Colors.white,
      cancelTextColor: AppColor.primary,
      buttonColor: AppColor.primary,
    );
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            const Text('Riwayat'),
            Expanded(
              child: Container(
                height: 40,
                margin: const EdgeInsets.all(12),
                child: TextField(
                  controller: searchController,
                  onTap: () async {
                    DateTime? result = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2023, 01, 01),
                      lastDate: DateTime(DateTime.now().year + 1),
                    );
                    if (result != null) {
                      searchController.text =
                          DateFormat('yyyy-MM-dd').format(result);
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColor.chart,
                    suffixIcon: IconButton(
                      onPressed: () {
                        cHistory.search(
                          cUser.data.idUser,
                          searchController.text,
                        );
                      },
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 16,
                    ),
                    hintText: '2022-06-01',
                  ),
                  keyboardType: TextInputType.none,
                  textAlignVertical: TextAlignVertical.center,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: GetBuilder<CHistory>(builder: (_) {
        if (_.loading) return const Center(child: CircularProgressIndicator());
        if (_.list.isEmpty) return const Center(child: Text('Tidak ada data'));
        return RefreshIndicator(
          onRefresh: () async => refresh(),
          child: ListView.builder(
            itemCount: _.list.length,
            itemBuilder: (context, index) {
              History history = _.list[index];
              return Card(
                elevation: 4,
                margin: EdgeInsets.fromLTRB(
                  16,
                  index == 0 ? 16 : 8,
                  16,
                  index == _.list.length - 1 ? 16 : 8,
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(4),
                  onTap: () {
                    Get.to(
                      () => DetailHistoryPage(
                          idUser: cUser.data.idUser!,
                          date: history.date!,
                          type: history.type!),
                    );
                  },
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 6,
                      ),
                      history.type == 'Pemasukan'
                          ? const Icon(Icons.south_west, color: Colors.green)
                          : const Icon(Icons.north_east, color: Colors.red),
                      const SizedBox(
                        width: 12,
                      ),
                      Text(
                        AppFormat.date(history.date!),
                        style: const TextStyle(
                          color: AppColor.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          AppFormat.currency(history.total!),
                          style: const TextStyle(
                            color: AppColor.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          delete(history.idHistory!);
                        },
                        icon:
                            Icon(Icons.delete_forever, color: Colors.red[300]),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
