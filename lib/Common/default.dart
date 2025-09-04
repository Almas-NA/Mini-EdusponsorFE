import 'package:flutter/material.dart';

class Default extends StatelessWidget {
  const Default({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Default")),

      //  body: StripesPayment(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Text(
            'This Feature is Under Development,\n please try again later',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
