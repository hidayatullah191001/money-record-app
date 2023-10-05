import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_money_record_app/config/app_asset.dart';
import 'package:getx_money_record_app/config/app_color.dart';
import 'package:getx_money_record_app/presentation/controllers/c_user.dart';
import 'package:getx_money_record_app/presentation/page/auth/login_page.dart';
import 'package:getx_money_record_app/presentation/widgets/button.dart';
import 'package:getx_money_record_app/presentation/widgets/form.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
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
                              controller: nameController,
                              labelText: 'Full Name',
                              prefixIcon: Icons.person,
                            ),
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
                                          cUser.register(
                                              nameController.text,
                                              emailController.text,
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
                          const Text('Sudah punya akun? '),
                          InkWell(
                            onTap: () => Get.back(),
                            child: const Text(
                              'Login',
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
