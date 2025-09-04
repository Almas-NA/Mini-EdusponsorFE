import 'package:flutter/material.dart';

class AdminSponsors extends StatefulWidget {
  const AdminSponsors({super.key});

  @override
  State<AdminSponsors> createState() => _AdminSponsorsState();
}

class _AdminSponsorsState extends State<AdminSponsors> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Sponsors"),),
    );
  }
}