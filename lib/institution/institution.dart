import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Institution extends StatefulWidget {
  const Institution({super.key});

  @override
  State<Institution> createState() => _InstitutionState();
}

class _InstitutionState extends State<Institution> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Institution Home")),
    );
  }
}