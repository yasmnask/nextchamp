import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class CustomToast {
  static void show(
    BuildContext context, {
    required String title,
    String? message,
    ToastificationType type = ToastificationType.success,
    Alignment alignment = Alignment.topCenter,
    Duration duration = const Duration(seconds: 4),
  }) {
    final style = _getToastStyle(type);

    toastification.show(
      context: context,
      type: type,
      style: ToastificationStyle.flatColored,
      alignment: alignment,
      autoCloseDuration: duration,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: style.textColor,
        ),
      ),
      description: message != null
          ? Text(
              message,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: style.textColor,
              ),
            )
          : null,
      icon: Icon(_getDefaultIcon(type), color: style.iconColor, size: 20),
      showIcon: true,
      primaryColor: style.borderColor,
      backgroundColor: style.backgroundColor,
      foregroundColor: style.textColor,
      borderRadius: BorderRadius.circular(12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
          spreadRadius: 0,
        ),
      ],
      showProgressBar: false,
      closeButton: const ToastCloseButton(showType: CloseButtonShowType.always),
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: false,
    );
  }

  static IconData _getDefaultIcon(ToastificationType type) {
    switch (type) {
      case ToastificationType.success:
        return Icons.check_circle;
      case ToastificationType.error:
        return Icons.error;
      case ToastificationType.warning:
        return Icons.warning;
      case ToastificationType.info:
      default:
        return Icons.info;
    }
  }

  static _ToastStyle _getToastStyle(ToastificationType type) {
    switch (type) {
      case ToastificationType.success:
        return const _ToastStyle(
          backgroundColor: Color(0xFFF1FBF2),
          textColor: Color(0xFF1F2937),
          iconColor: Color(0xFF22C55E),
          borderColor: Color(0xFF86EFAC),
        );
      case ToastificationType.error:
        return const _ToastStyle(
          backgroundColor: Color(0xFFFEF2F2),
          textColor: Color(0xFF1F2937),
          iconColor: Color(0xFFEF4444),
          borderColor: Color(0xFFFCA5A5),
        );
      case ToastificationType.warning:
        return const _ToastStyle(
          backgroundColor: Color(0xFFFEF9C3),
          textColor: Color(0xFF1F2937),
          iconColor: Color(0xFFEAB308),
          borderColor: Color(0xFFFDE047),
        );
      case ToastificationType.info:
      default:
        return const _ToastStyle(
          backgroundColor: Color(0xFFEFF6FF),
          textColor: Color(0xFF1F2937),
          iconColor: Color(0xFF3B82F6),
          borderColor: Color(0xFF93C5FD),
        );
    }
  }
}

class _ToastStyle {
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final Color borderColor;

  const _ToastStyle({
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    required this.borderColor,
  });
}
