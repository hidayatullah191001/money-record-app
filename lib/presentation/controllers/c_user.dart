import 'package:d_info/d_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_money_record_app/config/session.dart';
import 'package:getx_money_record_app/data/models/user.dart';
import 'package:getx_money_record_app/data/source/user_endpoint.dart';
import 'package:getx_money_record_app/presentation/page/auth/login_page.dart';
import 'package:getx_money_record_app/presentation/page/home_page.dart';
import 'package:getx_money_record_app/presentation/widgets/button.dart';
import 'package:lottie/lottie.dart';

class CUser extends GetxController {
  final _data = User().obs;
  User get data => _data.value;
  setData(n) => _data.value = n;

  final _token = ''.obs;
  String get token => _token.value;
  setToken(token) => _token.value = token;

  RxBool isLoading = false.obs;

  login(String email, String password) async {
    isLoading(true);
    try {
      bool success = await UserEndpoint.login(email, password);
      if (success) {
        isLoading(false);
        AlertSuccess('Berhasil login', const HomePage());
      } else {
        isLoading(false);
        Get.snackbar(
          'Gagal Login',
          'Email atau password salah',
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void register(String name, String email, String password) async {
    isLoading(true);
    try {
      await UserEndpoint.register(name, email, password);
      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }

  logout() {
    Get.dialog(
      Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset('assets/alert_animate.json', width: 50),
                const SizedBox(height: 10),
                const Text(
                  "Kamu yakin ingin\nkeluar dari aplikasi?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 109, 106, 106),
                        ),
                        onPressed: () => Get.back(),
                        child: const Text('Batal'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // bool success = await UserEndpoint.logout();
                          Session.removeUser();
                          Get.back();
                          AlertSuccess('Berhasil Logout', const LoginPage());
                        },
                        child: const Text('Keluar'),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void AlertSuccess(String message, dynamic page) {
    Get.dialog(
      Center(
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset('assets/success_animate.json', width: 200),
                Text(
                  message,
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
    Future.delayed(const Duration(seconds: 3), () {
      Get.back(); // Tutup dialog
      Get.off(page); // Arahkan pengguna ke halaman '/home'
    });
  }
}
