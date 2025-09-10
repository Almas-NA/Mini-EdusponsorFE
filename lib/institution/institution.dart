import 'package:edusponsor/config.dart';
import 'package:edusponsor/institution/components/instdashboard.dart';
import 'package:edusponsor/institution/components/instsettings.dart';
import 'package:edusponsor/institution/components/inststudentadd.dart';
import 'package:edusponsor/institution/cubit/instituteprofilecubit/institutionprofile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class Institution extends StatefulWidget {
  const Institution({super.key});

  @override
  State<Institution> createState() => _InstitutionState();
}

class _InstitutionState extends State<Institution> {
  int _selectedIndex = 0;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  Box box = Hive.box('eduSponsor');

  final List<dynamic> _pageTitles = [
    {"pageTitle": "Dashboard", "pageRoute": "/institution/dashboard"},
    {"pageTitle": "Students Add", "pageRoute": "/institution/students/add"},
    {"pageTitle": "Settings", "pageRoute": "/institution/settings"},
  ];

  void _getProfile() {
    Map body = {"id": box.get('userId')};
    context.read<InstitutionprofileCubit>().getInstitutionInfo(body);
  }

  @override
  void initState() {
    _getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 250,
            decoration: BoxDecoration(
              color: secondaryColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Profile Header
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24, width: 2),
                      ),
                      child: const CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white24,
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    BlocBuilder<InstitutionprofileCubit, InstitutionprofileState>(
                      builder: (context, state) {
                        return Column(
                          children: [
                            Text(
                              (state is InstitutionprofileInfoSuccess)
                                  ? "${state.institutionDetails['instituteName'] ?? ''}"
                                  : "Name",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Institution",
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: _pageTitles.length,
                    itemBuilder: (context, i) {
                      final bool isSelected = _selectedIndex == i;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedIndex = i;
                          });
                          _navigatorKey.currentState!.pushReplacementNamed(
                            '${_pageTitles[i]['pageRoute']}',
                          );
                        },
                        onHover: (hovering) {
                          if (hovering) {
                            setState(() => _hoverIndex = i);
                          } else {
                            setState(() => _hoverIndex = null);
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? primaryShadeLight
                                : _hoverIndex == i
                                ? Colors.white.withOpacity(0.05)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          child: ListTile(
                            leading: Icon(
                              _getIconForIndex(i),
                              color: Colors.white,
                            ),
                            title: Text(
                              _pageTitles[i]['pageTitle'],
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Top AppBar
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: secondaryShadeLight,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _pageTitles[_selectedIndex]['pageTitle'],
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Page Content
                Expanded(
                  child: Navigator(
                    key: _navigatorKey,
                    initialRoute: _pageTitles[0]['pageRoute'],
                    onGenerateRoute: (settings) {
                      switch (settings.name) {
                        case '/institution/dashboard':
                          return MaterialPageRoute(
                            builder: (_) => const InstitutionDashboard(),
                          );
                        case '/institution/students/add':
                          return MaterialPageRoute(
                            builder: (_) => const InstitutionStudentAdd(),
                          );
                        case '/institution/settings':
                          return MaterialPageRoute(
                            builder: (_) => const InstitutionSettings(),
                          );
                        default:
                          return MaterialPageRoute(
                            builder: (_) => const InstitutionDashboard(),
                          );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int? _hoverIndex;

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.dashboard;
      case 1:
        return Icons.school;
      case 2:
        return Icons.settings;
      case 3:
        return Icons.settings;
      default:
        return Icons.circle;
    }
  }
}