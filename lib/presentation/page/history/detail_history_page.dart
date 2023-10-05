import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_money_record_app/config/app_color.dart';
import 'package:getx_money_record_app/config/app_format.dart';
import 'package:intl/intl.dart';

import '../../controllers/history/c_detail_history copy.dart';

class DetailHistoryPage extends StatefulWidget {
  final String idUser;
  final String date;
  final String type;
  const DetailHistoryPage(
      {Key? key, required this.idUser, required this.date, required this.type})
      : super(key: key);

  @override
  _DetailHistoryPageState createState() => _DetailHistoryPageState();
}

class _DetailHistoryPageState extends State<DetailHistoryPage> {
  final cDetailHistory = Get.put(CDetailHistory());

  @override
  void initState() {
    cDetailHistory.getData(widget.idUser, widget.date, widget.type);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        actions: [
          cDetailHistory.data.type == 'Pemasukan'
              ? Icon(
                  Icons.south_west,
                  color: Colors.green[300],
                )
              : Icon(
                  Icons.north_east,
                  color: Colors.red[300],
                ),
          const SizedBox(
            width: 15,
          )
        ],
        title: Text(AppFormat.date(widget.date.toString())),
      ),
      body: GetBuilder<CDetailHistory>(builder: (_) {
        if (_.loading == true) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (_.data.date == null) {
          if (widget.type == 'Pengeluaran') {
            return const Center(
              child: Text('Belum ada pengeluaran'),
            );
          } else {
            return const Center(
              child: Text('Belum ada'),
            );
          }
        }

        List details = jsonDecode(_.data.details!);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              const Text('Total'),
              const SizedBox(
                height: 6,
              ),
              Text(
                AppFormat.currency(_.data.total!),
                style: const TextStyle(
                  color: AppColor.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 5,
                width: 100,
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: details.length,
                  separatorBuilder: (context, index) => const Divider(
                    height: 16,
                    endIndent: 16,
                    indent: 16,
                  ),
                  itemBuilder: (context, index) {
                    Map item = details[index];
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Text('${index + 1}.'),
                          const SizedBox(width: 8),
                          Expanded(child: Text(item['name'])),
                          Text(AppFormat.currency(item['price'])),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
