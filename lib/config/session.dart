import 'dart:convert';

import 'package:get/get.dart';
import 'package:getx_money_record_app/data/models/user.dart';
import 'package:getx_money_record_app/presentation/controllers/c_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static Future<bool> saveUser(User user) async {
    final pref = await SharedPreferences.getInstance();
    Map<String, dynamic> mapUser = user.toJson();
    String stringUser = jsonEncode(mapUser);
    bool success = await pref.setString('user', stringUser);
    if (success) {
      final cUser = Get.put(CUser());
      cUser.setData(user);
    }
    return success;
  }

  static Future<User> getUser() async {
    User user = User();
    final pref = await SharedPreferences.getInstance();
    String? stringUser = pref.getString('user');
    if (stringUser != null) {
      Map<String, dynamic> mapUser = jsonDecode(stringUser);
      user = User.fromJson(mapUser);
      final cUser = Get.put(CUser());
      cUser.setData(user);
    }
    return user;
  }

  // static Future<bool?> setToken(String token) async {
  //   final pref = await SharedPreferences.getInstance();
  //   bool tokenUser = await pref.setString('token', token);
  //   if (tokenUser != null) {
  //     final cUser = Get.put(CUser());
  //     cUser.setToken(tokenUser);
  //   }
  //   return tokenUser;
  // }

  // static Future<String?> getToken() async {
  //   final pref = await SharedPreferences.getInstance();
  //   String? tokenUser = pref.getString('token');
  //   if (tokenUser != null) {
  //     final cUser = Get.put(CUser());
  //     cUser.setToken(tokenUser);
  //   }
  //   return tokenUser;
  // }

  static Future<bool> removeUser() async {
    final pref = await SharedPreferences.getInstance();
    bool success = await pref.remove('user');
    return success;
  }

  // static Future<bool> removeToken() async {
  //   final pref = await SharedPreferences.getInstance();
  //   bool success = await pref.remove('token');
  //   return success;
  // }
}
