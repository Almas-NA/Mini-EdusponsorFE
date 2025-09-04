import 'package:edusponsor/Common/enums/response_type_enum.dart';
import 'package:edusponsor/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
void displaySnackBar({
  String? message,
  Color? color,
  String? type = 'ERROR',
}) {
  final Color errorColor = Colors.red[700]!;
  final Color successColor = Colors.green[900]!;
  const Color warningColor = Color.fromARGB(255, 172, 130, 7);
  Color? backgroundColor;

  if (color == null) {
    if (type == ServerResponseType.ERROR.name) {
      backgroundColor = errorColor;
    } else if (type == ServerResponseType.SUCCESS.name) {
      backgroundColor = successColor;
    } else if (type == ServerResponseType.WARNING.name) {
      backgroundColor = warningColor;
    } else if (type == ServerResponseType.MULTI_LINE_WARNING.name) {
      backgroundColor = errorColor;
    }
  } else {
    backgroundColor = color;
  }

  final double maxWidth = kIsWeb ? 500.0 : MediaQueryData.fromView(WidgetsBinding.instance.window).size.width * 0.90;

  final snackBar = SnackBar(
    width: maxWidth,
    behavior: SnackBarBehavior.floating,
    padding: const EdgeInsets.symmetric(
      horizontal: 12,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    elevation: 5,
    backgroundColor: backgroundColor,
    content: Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: Container(
        constraints: const BoxConstraints(minHeight: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                message.toString().replaceAll('<br>', '\n'),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    ),
  );
  if (message != null) {
    // rootScaffoldMessengerKey.currentState!.hideCurrentSnackBar();
    rootScaffoldMessengerKey.currentState!.removeCurrentSnackBar();
    rootScaffoldMessengerKey.currentState!.showSnackBar(snackBar);
  }
}