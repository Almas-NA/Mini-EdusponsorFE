import 'package:edusponsor/config.dart';
import 'package:edusponsor/sponsor/components/sponsdashboard.dart';
import 'package:edusponsor/sponsor/components/sponsinstitutions.dart';
import 'package:edusponsor/sponsor/components/sponssettings.dart';
import 'package:edusponsor/sponsor/cubit/sponsorinfocubit/sponsorinfo_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class Sponsor extends StatefulWidget {
  const Sponsor({super.key});

  @override
  State<Sponsor> createState() => _SponsorState();
}

class _SponsorState extends State<Sponsor> {
  Box box = Hive.box('eduSponsor');
  int _selectedIndex = 0;

  final List<Widget> _pages = [SponsorDashboard(),SponsorInstitutions(),SponsorSettings()];

  void _getProfile() {
    Map body = {"id": box.get('userId')};
    context.read<SponsorinfoCubit>().getSponsorInfo(body);
  }

  @override
  void initState() {
    _getProfile();
    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryShade.shade50,

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: true,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryShade.shade600, secondaryShade.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryShade.shade200.withOpacity(0.6),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          ),
          title: Text(
            _selectedIndex == 0 ? "Dashboard":(_selectedIndex == 1)?"Institution":"Settings",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18 * scalefactor,
              color: Colors.white,
              letterSpacing: 0.5,
              shadows: [
                Shadow(
                  offset: const Offset(1, 1),
                  blurRadius: 3,
                  color: Colors.black26,
                ),
              ],
            ),
          ),
          centerTitle: true,
        ),
      ),
      drawer: _buildDrawer(context),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: _pages[_selectedIndex],
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: BlocBuilder<SponsorinfoCubit, SponsorinfoState>(
        builder: (context, state) {
          if (state is SponsorinfoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SponsorinfoError) {
            return const Center(child: Text("Failed to load student info"));
          } else if (state is SponsorinfoLoaded) {
            final sponsordetails = state.sponsordetails;

            return Column(
              children: [
                // 🌊 Attractive Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 40, bottom: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryShade.shade500, secondaryShade.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 35 * scalefactor,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 42 * scalefactor,
                          color: primaryShade,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "${sponsordetails['fullName']}",
                        style: TextStyle(
                          fontSize: 16 * scalefactor,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        sponsordetails['email'] ?? "",
                        style: TextStyle(
                          fontSize: 13 * scalefactor,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                _buildDrawerItem(Icons.dashboard_rounded, "Dashboard", 0),
                _buildDrawerItem(Icons.settings_rounded, "Institution", 1),
                _buildDrawerItem(Icons.settings_rounded, "Settings", 2),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12,
                  ),
                  child: Column(
                    children: [
                      const Divider(),
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red.shade50,
                          ),
                          child: Icon(
                            Icons.logout_rounded,
                            color: Colors.red.shade400,
                          ),
                        ),
                        title: Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 14 * scalefactor,
                            fontWeight: FontWeight.w600,
                            color: Colors.red.shade400,
                          ),
                        ),
                        onTap: () {
                          // TODO: add logout function
                        },
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "EduSponsor v1.0.0",
                        style: TextStyle(
                          fontSize: 12 * scalefactor,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String label, int index) {
    final bool isSelected = _selectedIndex == index;
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? primaryShade.shade50 : Colors.transparent,
        ),
        child: Icon(icon, color: isSelected ? primaryShade : Colors.grey[600]),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 14 * scalefactor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? primaryShade : Colors.black87,
        ),
      ),
      selected: isSelected,
      selectedTileColor: primaryShade.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () {
        setState(() => _selectedIndex = index);
        Navigator.pop(context);
      },
    );
  }
}
