import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_money_record_app/config/app_color.dart';
import 'package:getx_money_record_app/config/app_format.dart';
import 'package:getx_money_record_app/data/source/history_endpoint.dart';
import 'package:getx_money_record_app/presentation/controllers/c_user.dart';
import 'package:getx_money_record_app/presentation/controllers/history/c_add_history.dart';
import 'package:getx_money_record_app/presentation/controllers/history/c_update_history.dart';
import 'package:getx_money_record_app/presentation/widgets/button.dart';
import 'package:getx_money_record_app/presentation/widgets/form.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class UpdateHistoryPage extends StatefulWidget {
  final String date;
  final String type;
  final String idHistory;
  UpdateHistoryPage(
      {Key? key,
      required this.date,
      required this.type,
      required this.idHistory})
      : super(key: key);

  @override
  State<UpdateHistoryPage> createState() => _UpdateHistoryPageState();
}

class _UpdateHistoryPageState extends State<UpdateHistoryPage> {
  final cUpdateHistory = Get.put(CUpdateHistory());
  final cUser = Get.put(CUser());
  final priceController = TextEditingController();
  final nameController = TextEditingController();

  updateHistory() async {
    cUpdateHistory.isLoading(true);
    try {
      bool success = await HistoryEndpoint.updateHistory(
        widget.idHistory,
        cUser.data.idUser!,
        cUpdateHistory.date,
        cUpdateHistory.type,
        jsonEncode(cUpdateHistory.items),
        cUpdateHistory.total.toString(),
      );
      if (success) {
        cUpdateHistory.isLoading(false);
        Get.dialog(
          Center(
            child: Card(
              child: Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset('assets/success_animate.json', width: 200),
                    const Text(
                      'History berhasil diperbarui',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
          barrierDismissible: false,
        );
        Future.delayed(const Duration(milliseconds: 3000), () {
          Get.back();
          Get.back(result: true);
        });
      }
    } catch (e) {
      Get.snackbar('Failed', e.toString());
    }
  }

  @override
  void initState() {
    cUpdateHistory.init(cUser.data.idUser, widget.date, widget.type);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update History'),
      ),
      body: GetBuilder<CUpdateHistory>(builder: (_) {
        if (_.loading) return const Center(child: CircularProgressIndicator());
        return ListView(
          padding: const EdgeInsets.all(10),
          children: [
            const Text('Tanggal'),
            Row(
              children: [
                Obx(
                  () => Text(cUpdateHistory.date),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    DateTime? result = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2023, 01, 01),
                      lastDate: DateTime(DateTime.now().year + 1),
                    );
                    if (result != null) {
                      cUpdateHistory.setDate(
                        DateFormat('yyyy-MM-dd').format(result),
                      );
                    }
                  },
                  icon: const Icon(Icons.event),
                  label: const Text('Pilih'),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Obx(() {
              return DropdownButtonFormField(
                value: cUpdateHistory.type,
                items: ['Pemasukan', 'Pengeluaran']
                    .map((e) => DropdownMenuItem(
                          child: Text(e),
                          value: e,
                        ))
                    .toList(),
                onChanged: (value) {
                  cUpdateHistory.setType(value);
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
                  ),
                  labelText: 'Tipe',
                  isDense: true,
                  prefixIcon: const Icon(Icons.select_all),
                ),
              );
            }),
            const SizedBox(
              height: 12,
            ),
            HistoryTextFormField(
              controller: nameController,
              labelText: 'Sumber/Objek Pengeluaran',
              prefixIcon: Icons.flag,
            ),
            HistoryTextFormField(
              controller: priceController,
              labelText: 'Harga',
              prefixIcon: Icons.price_change,
              inputType: TextInputType.number,
            ),
            Center(
              child: Container(
                height: 4,
                width: 100,
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {
                cUpdateHistory.addItem(
                  {'name': nameController.text, 'price': priceController.text},
                );
                nameController.clear();
                priceController.clear();
              },
              child: const Text('Tambah ke Items'),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text('Items'),
            const SizedBox(
              height: 5,
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(),
              ),
              child: GetBuilder<CUpdateHistory>(builder: (_) {
                return Wrap(
                  spacing: 8,
                  children: List.generate(
                    _.items.length,
                    (index) => Chip(
                      label: Text(_.items[index]['name']),
                      deleteIcon: const Icon(Icons.clear),
                      onDeleted: () => _.deleteItem(index),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Obx(() {
                  return Text(
                    AppFormat.currency(cUpdateHistory.total.toString()),
                    style: const TextStyle(
                      color: AppColor.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Obx(
              () => cUpdateHistory.isLoading.value == true
                  ? CustomButton(
                      onTap: () {},
                      title: 'PLEASE WAIT...',
                    )
                  : CustomButton(
                      onTap: () => updateHistory(),
                      title: 'SUBMIT',
                    ),
            ),
          ],
        );
      }),
    );
  }
}
