import 'package:flutter/material.dart';
import 'package:getx_money_record_app/config/app_color.dart';

class CustomButton extends StatelessWidget {
  VoidCallback onTap;
  final String title;
  EdgeInsetsGeometry padding;
  CustomButton(
      {Key? key,
      required this.onTap,
      required this.title,
      this.padding = const EdgeInsets.symmetric(
        vertical: 15,
      )})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.primary,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: padding,
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColor.bg,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
