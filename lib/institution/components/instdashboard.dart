import 'package:flutter/material.dart';

class InstitutionDashboard extends StatefulWidget {
  const InstitutionDashboard({super.key});

  @override
  State<InstitutionDashboard> createState() => _InstitutionDashboardState();
}

class _InstitutionDashboardState extends State<InstitutionDashboard> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Dashboard'),
      ),
    );
  }
}