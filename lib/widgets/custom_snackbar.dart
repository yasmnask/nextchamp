import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class CustomSnackbar {
  static void show(
    BuildContext context, {
    required String title,
    required String message,
    required ContentType contentType,
    SnackBarBehavior behavior = SnackBarBehavior.floating, // floating or fixed
    Alignment alignment =
        Alignment.bottomCenter, // posisi: bawah (default) atau atas
  }) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: behavior,
      backgroundColor: Colors.transparent,
      margin: alignment == Alignment.topCenter
          ? const EdgeInsets.only(top: 20, left: 16, right: 16)
          : const EdgeInsets.only(bottom: 20, left: 16, right: 16),
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
