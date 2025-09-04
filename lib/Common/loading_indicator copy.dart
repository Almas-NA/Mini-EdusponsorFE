import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key, this.themeColor});

  final Color? themeColor;

  @override
  Widget build(BuildContext context) => Center(
    child: SpinKitCircle(
      size: 60,
      color: themeColor ?? Theme.of(context).primaryColor,
    ),
  );
}
