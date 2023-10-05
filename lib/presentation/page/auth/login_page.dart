// ignore_for_file: use_build_context_synchronously

import 'package:d_info/d_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_money_record_app/config/app_asset.dart';
import 'package:getx_money_record_app/config/app_color.dart';
import 'package:getx_money_record_app/data/source/user_endpoint.dart';
import 'package:getx_money_record_app/presentation/controllers/c_user.dart';
import 'package:getx_money_record_app/presentation/page/auth/register_page.dart';
import 'package:getx_money_record_app/presentation/page/home_page.dart';
import 'package:getx_money_record_app/presentation/widgets/button.dart';
import 'package:getx_money_record_app/presentation/widgets/form.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final cUser = Get.put(CUser());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraint.maxHeight,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    Image.asset(
                      AppAsset.logo,
                      width: 100,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            CustomTextFormField(
                              controller: emailController,
                              labelText: 'Email Address',
                              prefixIcon: Icons.email,
                            ),
                            CustomTextFormField(
                              controller: passwordController,
                              labelText: 'Password',
                              prefixIcon: Icons.password,
                              obsecureText: true,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Obx(
                              () => cUser.isLoading.value == true
                                  ? const CircularProgressIndicator(
                                      color: AppColor.primary,
                                    )
                                  : CustomButton(
                                      onTap: () {
                                        if (formKey.currentState!.validate()) {
                                          cUser.login(emailController.text,
                                              passwordController.text);
                                        }
                                      },
                                      title: 'LOGIN',
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Belum punya akun? '),
                          InkWell(
                            onTap: () => Get.to(RegisterPage()),
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                color: AppColor.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
