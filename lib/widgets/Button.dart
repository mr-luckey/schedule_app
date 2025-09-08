import 'package:flutter/material.dart';
import 'package:schedule_app/theme/app_colors.dart';
// import 'package:wedding_booking_app/Constants/Colors.dart';

// ignore: must_be_immutable
class GreenButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final bool? isIcon;
  Function()? onPressed;
  final Color color;
  final Color textColor;
  final double height;
  final double width;
  GreenButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.color,
    required this.textColor,
    required this.height,
    required this.width,
    this.icon,
    this.isIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: isIcon == true
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  Icon(icon, color: textColor),
                  Text(text, style: TextStyle(color: textColor)),
                ],
              )
            : Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}

class SimpleButton extends StatelessWidget {
  final String text;
  // final Color color;
  final Color textColor;
  final double height;
  final double width;
  SimpleButton({
    super.key,
    required this.text,
    // required this.color,
    required this.textColor,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        // color: AppColors.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
