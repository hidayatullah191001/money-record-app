import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_money_record_app/config/api.dart';
import 'package:getx_money_record_app/config/app_request.dart';
import 'package:getx_money_record_app/config/session.dart';
import 'package:getx_money_record_app/data/models/user.dart';
import 'package:getx_money_record_app/presentation/controllers/c_user.dart';
import 'package:getx_money_record_app/presentation/page/auth/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserEndpoint {
  static Future<bool> login(String email, String password) async {
    String url = "${Api.user}/login.php";
    Map? responseBody = await AppRequest.post(
      url,
      body: {
        'email': email,
        'password': password,
      },
    );
    if (responseBody == null) return false;

    if (responseBody['success']) {
      var mapUser = responseBody['data'];
      Session.saveUser(User.fromJson(mapUser));

      return true;
    }
    return false;
  }

  static Future<bool> register(
      String name, String email, String password) async {
    String url = '${Api.user}/register.php';
    Map? responseBody = await AppRequest.post(
      url,
      body: {
        'name': name,
        'email': email,
        'password': password,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String()
      },
    );

    if (responseBody == null) return false;

    if (responseBody['success']) {
      final cuser = Get.put(CUser());
      cuser.AlertSuccess('Berhasil Register', const LoginPage());
      return true;
    } else {
      if (responseBody['message'] == 'email') {
        Get.snackbar('Gagal Register', 'Email sudah terdaftar',
            backgroundColor: Colors.red, colorText: Colors.white);
      } else {
        Get.snackbar('Gagal Register', 'Something went wrong!',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
    return false;
  }

  // static Future<bool> logout() async {
  //   String url = Api.baseUrl + '/logout';
  //   final cuser = Get.put(CUser());
  //   final userToken = cuser.token;
  //   Map? responseBody = await AppRequest.post(
  //     url,
  //     headers: {'Authorization': 'Bearer $userToken'},
  //   );
  //   Session.removeUser();
  //   if (responseBody!['meta']['code'] == 200) {
  //     return true;
  //   }
  //   return false;
  // }
}
