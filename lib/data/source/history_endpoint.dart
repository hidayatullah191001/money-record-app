import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_money_record_app/config/api.dart';
import 'package:getx_money_record_app/config/app_request.dart';
import 'package:getx_money_record_app/data/models/history.dart';
import 'package:getx_money_record_app/presentation/controllers/c_user.dart';
import 'package:getx_money_record_app/presentation/page/home_page.dart';
import 'package:intl/intl.dart';

class HistoryEndpoint {
  static Future<Map> analysis(String idUser) async {
    String url = "${Api.history}/analysis.php";
    Map? responseBody = await AppRequest.post(
      url,
      body: {
        'id_user': idUser,
        'today': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      },
    );
    if (responseBody == null) {
      return {
        'today': 0.0,
        'yesterday': 0.0,
        'week': [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
        'month': {
          'income': 0.0,
          'outcome': 0.0,
        }
      };
    }

    return responseBody;
  }

  static Future<bool> addHistory(String idUser, String date, String type,
      String details, String total) async {
    String url = '${Api.history}/add.php';
    Map? responseBody = await AppRequest.post(
      url,
      body: {
        'id_user': idUser,
        'date': date,
        'type': type,
        'details': details,
        'total': total,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String()
      },
    );

    if (responseBody == null) return false;

    if (responseBody['success']) {
      final cuser = Get.put(CUser());
      return true;
    } else {
      if (responseBody['message'] == 'date') {
        Get.snackbar('Gagal Tambah Data',
            'History dengan tanggal tersebut sudah pernah dibuat',
            backgroundColor: Colors.red, colorText: Colors.white);
      } else {
        Get.snackbar('Gagal Register', 'Something went wrong!',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
    return false;
  }

  static Future<List<History>> incomeOutcome(String idUser, String type) async {
    String url = "${Api.history}/income_outcome.php";
    Map? responseBody = await AppRequest.post(
      url,
      body: {
        'id_user': idUser,
        'type': type,
      },
    );
    if (responseBody == null) return [];
    if (responseBody['success']) {
      List list = responseBody['data'];
      return list.map((e) => History.fromJson(e)).toList();
    }
    return [];
  }

  static Future<List<History>> incomeOutcomeSearch(
      String idUser, String type, String date) async {
    String url = "${Api.history}/income_outcome_search.php";
    Map? responseBody = await AppRequest.post(
      url,
      body: {'id_user': idUser, 'type': type, 'date': date},
    );
    if (responseBody == null) return [];
    if (responseBody['success']) {
      List list = responseBody['data'];
      return list.map((e) => History.fromJson(e)).toList();
    }
    return [];
  }

  static Future<History?> whereDate(
      String idUser, String date, String type) async {
    String url = "${Api.history}/where_date.php";
    Map? responseBody = await AppRequest.post(
      url,
      body: {
        'id_user': idUser,
        'date': date,
        'type': type,
      },
    );
    if (responseBody == null) return null;
    if (responseBody['success']) {
      var e = responseBody['data'];
      return History.fromJson(e);
    }
    return null;
  }

  static Future<History?> whereDateHistory(String idUser, String date) async {
    String url = "${Api.history}/where_date.php";
    Map? responseBody = await AppRequest.post(
      url,
      body: {
        'id_user': idUser,
        'date': date,
      },
    );
    if (responseBody == null) return null;
    if (responseBody['success']) {
      var e = responseBody['data'];
      return History.fromJson(e);
    }
    return null;
  }

  static Future<bool> updateHistory(String idHistory, String idUser,
      String date, String type, String details, String total) async {
    String url = '${Api.history}/update.php';
    Map? responseBody = await AppRequest.post(
      url,
      body: {
        'id_history': idHistory,
        'id_user': idUser,
        'date': date,
        'type': type,
        'details': details,
        'total': total,
        'updated_at': DateTime.now().toIso8601String()
      },
    );

    if (responseBody == null) return false;

    if (responseBody['success']) {
      final cuser = Get.put(CUser());
      return true;
    } else {
      if (responseBody['message'] == 'date') {
        Get.snackbar('Gagal Update Data',
            'History dengan tanggal tersebut sudah pernah dibuat',
            backgroundColor: Colors.red, colorText: Colors.white);
      } else {
        Get.snackbar('Gagal Register', 'Something went wrong!',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
    return false;
  }

  static Future<bool> deleteHistory(String idHistory) async {
    String url = '${Api.history}/delete.php';
    Map? responseBody = await AppRequest.post(
      url,
      body: {
        'id_history': idHistory,
      },
    );
    if (responseBody == null) return false;
    return responseBody['success'];
  }

  static Future<List<History>> history(String idUser) async {
    String url = "${Api.history}/history.php";
    Map? responseBody = await AppRequest.post(
      url,
      body: {
        'id_user': idUser,
      },
    );
    if (responseBody == null) return [];
    if (responseBody['success']) {
      List list = responseBody['data'];
      return list.map((e) => History.fromJson(e)).toList();
    }
    return [];
  }

  static Future<List<History>> historySearch(String idUser, String date) async {
    String url = "${Api.history}/history_search.php";
    Map? responseBody = await AppRequest.post(
      url,
      body: {'id_user': idUser, 'date': date},
    );
    if (responseBody == null) return [];
    if (responseBody['success']) {
      List list = responseBody['data'];
      return list.map((e) => History.fromJson(e)).toList();
    }
    return [];
  }
}
