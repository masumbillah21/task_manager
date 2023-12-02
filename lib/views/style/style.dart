import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/utility/utilities.dart';

const Color colorRed = Color.fromRGBO(231, 28, 36, 1);
const Color colorPink = Color.fromRGBO(203, 12, 159, 1);
const Color colorGreen = Color.fromRGBO(33, 191, 115, 1);
const Color colorBlue = Color.fromRGBO(23, 193, 232, 1.0);
const Color colorOrange = Color.fromRGBO(230, 126, 34, 1.0);
const Color colorWhite = Color.fromRGBO(255, 255, 255, 1.0);
const Color colorDarkBlue = Color.fromRGBO(44, 62, 80, 1.0);
const Color colorGray = Color.fromRGBO(96, 95, 95, 1.0);
const Color colorLight = Color.fromRGBO(211, 211, 211, 1.0);

SizedBox itemSizeBox({Widget? child}) {
  return SizedBox(
    width: double.infinity,
    child: Container(
      padding: const EdgeInsets.all(10),
      child: child,
    ),
  );
}

PinTheme appOTPStyle() {
  return PinTheme(
    inactiveColor: colorLight,
    inactiveFillColor: colorWhite,
    selectedColor: colorGreen,
    activeColor: colorWhite,
    selectedFillColor: colorGreen,
    shape: PinCodeFieldShape.box,
    borderRadius: BorderRadius.circular(5),
    fieldHeight: 50,
    borderWidth: 0.5,
    fieldWidth: 45,
    activeFillColor: Colors.white,
  );
}

TextStyle head1Text(Color textColor) {
  return TextStyle(
    color: textColor,
    fontSize: 28,
    fontFamily: 'poppins',
    fontWeight: FontWeight.w700,
  );
}

TextStyle head2Text(Color textColor) {
  return TextStyle(
      color: textColor,
      fontSize: 18,
      fontFamily: 'poppins',
      fontWeight: FontWeight.w500);
}

TextStyle head3Text(Color textColor) {
  return TextStyle(
      color: textColor,
      fontSize: 14,
      fontFamily: 'poppins',
      fontWeight: FontWeight.w500);
}

TextStyle head4Text(Color textColor) {
  return TextStyle(
      color: textColor,
      fontSize: 12,
      fontFamily: 'poppins',
      fontWeight: FontWeight.w800);
}

TextStyle head5Text(Color textColor) {
  return TextStyle(
      color: textColor,
      fontSize: 13,
      fontFamily: 'poppins',
      fontWeight: FontWeight.w500);
}

TextStyle buttonTextStyle() {
  return const TextStyle(
    fontSize: 14,
    fontFamily: 'poppins',
    fontWeight: FontWeight.w400,
    color: colorWhite,
  );
}

Ink buttonChild({String buttonText = ''}) {
  return Ink(
    decoration: BoxDecoration(
      color: colorGreen,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Container(
      height: 45,
      alignment: Alignment.center,
      child: buttonText.isEmpty
          ? const Icon(Icons.arrow_circle_right_outlined)
          : Text(
              buttonText,
              style: buttonTextStyle(),
            ),
    ),
  );
}

Widget appStatusBar({String? taskStatus, Color? backgroundColor}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      taskStatus!,
      style: head3Text(colorWhite),
    ),
  );
}

Widget profileImage({imageProvider, double radius = 25}) {
  return imageProvider != null
      ? CircleAvatar(
          radius: radius,
          backgroundColor: colorWhite,
          backgroundImage: MemoryImage(showBase64Image(imageProvider)),
        )
      : CircleAvatar(
          radius: radius,
          backgroundColor: colorWhite,
          backgroundImage: const AssetImage("assets/images/placeholder.png"),
        );
}

void successToast(msg) {
  Fluttertoast.showToast(
    msg: msg,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    toastLength: Toast.LENGTH_SHORT,
    backgroundColor: colorGreen,
    textColor: colorWhite,
    fontSize: 16.0,
  );
}

void errorToast(msg) {
  Fluttertoast.showToast(
    msg: msg,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    toastLength: Toast.LENGTH_SHORT,
    backgroundColor: colorRed,
    textColor: colorWhite,
    fontSize: 16.0,
  );
}
