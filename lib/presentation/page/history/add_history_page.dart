import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_money_record_app/config/app_color.dart';
import 'package:getx_money_record_app/config/app_format.dart';
import 'package:getx_money_record_app/data/source/history_endpoint.dart';
import 'package:getx_money_record_app/presentation/controllers/c_user.dart';
import 'package:getx_money_record_app/presentation/controllers/history/c_add_history.dart';
import 'package:getx_money_record_app/presentation/page/home_page.dart';
import 'package:getx_money_record_app/presentation/widgets/button.dart';
import 'package:getx_money_record_app/presentation/widgets/form.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class AddHistoryPage extends StatefulWidget {
  const AddHistoryPage({Key? key}) : super(key: key);

  @override
  State<AddHistoryPage> createState() => _AddHistoryPageState();
}

class _AddHistoryPageState extends State<AddHistoryPage> {
  final cAddHistory = Get.put(CAddHistory());
  final cUser = Get.put(CUser());
  final priceController = TextEditingController();
  final nameController = TextEditingController();

  addHistory() async {
    bool success = await HistoryEndpoint.addHistory(
      cUser.data.idUser!,
      cAddHistory.date,
      cAddHistory.type,
      jsonEncode(cAddHistory.items),
      cAddHistory.total.toString(),
    );
    if (success) {
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
                    'History berhasil ditambahkan',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
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
        Get.back();
        Get.back(result: true); // T/ Tutup dikan pengguna ke halaman '/home'
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Baru'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          const Text('Tanggal'),
          Row(
            children: [
              Obx(
                () => Text(cAddHistory.date),
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
                    cAddHistory.setDate(
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
              value: cAddHistory.type,
              items: ['Pemasukan', 'Pengeluaran']
                  .map((e) => DropdownMenuItem(
                        child: Text(e),
                        value: e,
                      ))
                  .toList(),
              onChanged: (value) {
                cAddHistory.setType(value);
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
              cAddHistory.addItem(
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
            child: GetBuilder<CAddHistory>(builder: (_) {
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
                  AppFormat.currency(cAddHistory.total.toString()),
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
          CustomButton(onTap: () => addHistory(), title: 'SUBMIT'),
        ],
      ),
    );
  }
}
