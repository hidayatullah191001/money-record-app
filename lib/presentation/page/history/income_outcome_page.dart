import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_money_record_app/config/app_color.dart';
import 'package:getx_money_record_app/config/app_format.dart';
import 'package:getx_money_record_app/data/models/history.dart';
import 'package:getx_money_record_app/data/source/history_endpoint.dart';
import 'package:getx_money_record_app/presentation/controllers/c_user.dart';
import 'package:getx_money_record_app/presentation/controllers/history/c_income_outcome.dart';
import 'package:getx_money_record_app/presentation/page/history/detail_history_page.dart';
import 'package:getx_money_record_app/presentation/page/history/update_history_page.dart';
import 'package:intl/intl.dart';

class IncomeOutcomePage extends StatefulWidget {
  final String type;
  const IncomeOutcomePage({Key? key, required this.type}) : super(key: key);

  @override
  State<IncomeOutcomePage> createState() => _IncomeOutcomePageState();
}

class _IncomeOutcomePageState extends State<IncomeOutcomePage> {
  final cInOut = Get.put(CIncomeOutcome());
  final cUser = Get.put(CUser());
  final searchController = TextEditingController();

  refresh() {
    cInOut.getList(cUser.data.idUser!, widget.type);
  }

  menuOption(String value, History history) {
    if (value == 'update') {
      Get.to(() => UpdateHistoryPage(
            date: history.date!,
            type: widget.type,
            idHistory: history.idHistory!,
          ))?.then((value) {
        if (value ?? true) {
          refresh();
        }
      });
    } else if (value == 'delete') {
      Get.defaultDialog(
        title: 'Hapus history',
        content: const Text('Yakin ingin menghapus data?'),
        textConfirm: 'Hapus',
        textCancel: 'Batal',
        onConfirm: () async {
          bool success =
              await HistoryEndpoint.deleteHistory(history.idHistory!);
          if (success) refresh();
          Get.back();
        },
        confirmTextColor: Colors.white,
        cancelTextColor: AppColor.primary,
        buttonColor: AppColor.primary,
      );
    }
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
            Text(widget.type),
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
                        cInOut.search(
                          cUser.data.idUser,
                          widget.type,
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
      body: GetBuilder<CIncomeOutcome>(builder: (_) {
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
                        type: history.type!,
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 18,
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
                      PopupMenuButton<String>(
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'update',
                            child: Text('Update'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ],
                        onSelected: (value) => menuOption(value, history),
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
