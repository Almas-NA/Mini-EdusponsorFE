import 'package:edusponsor/student/components/studdashboard.dart';
import 'package:flutter/material.dart';
import 'package:edusponsor/config.dart';

class Student extends StatefulWidget {
  const Student({super.key});

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student> {
  int _selectedIndex = 0; // 0 = Dashboard, 1 = Profile, 2 = Settings

  final List<Widget> _pages = [
    const StudentDashboard(),
    const _ProfilePage(),
    const _SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryShade.shade50,

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60), // custom height
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
            _selectedIndex == 0
                ? "Dashboard"
                : _selectedIndex == 1
                ? "Profile"
                : "Settings",
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
      drawer: _buildDrawer(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: _pages[_selectedIndex],
      ),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
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
                  "Student Name",
                  style: TextStyle(
                    fontSize: 16 * scalefactor,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "student@email.com",
                  style: TextStyle(
                    fontSize: 13 * scalefactor,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),

          // 📌 Drawer Items
          const SizedBox(height: 10),
          _buildDrawerItem(Icons.dashboard_rounded, "Dashboard", 0),
          _buildDrawerItem(Icons.person_rounded, "Profile", 1),
          _buildDrawerItem(Icons.settings_rounded, "Settings", 2),

          const Spacer(),

          // 🔽 Footer Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
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
                    // TODO: Handle logout
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

// 📍 Profile Page
class _ProfilePage extends StatelessWidget {
  const _ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.white,
        elevation: 8,
        shadowColor: primaryShade.shade200,
        margin: const EdgeInsets.all(24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 45 * scalefactor,
                backgroundColor: secondaryShade.shade400,
                child: Icon(Icons.person, size: 52, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                "Student Name",
                style: TextStyle(
                  fontSize: 18 * scalefactor,
                  fontWeight: FontWeight.bold,
                  color: primaryShade.shade700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "student@email.com",
                style: TextStyle(
                  fontSize: 14 * scalefactor,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryShade,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                ),
                icon: const Icon(Icons.edit, size: 18),
                label: Text(
                  "Edit Profile",
                  style: TextStyle(fontSize: 14 * scalefactor),
                ),
                onPressed: () {
                  // TODO: handle edit profile
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 📍 Settings Page (placeholder)
class _SettingsPage extends StatelessWidget {
  const _SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Settings Page (Coming Soon)",
        style: TextStyle(
          fontSize: 16 * scalefactor,
          fontWeight: FontWeight.w500,
          color: Colors.grey[700],
        ),
      ),
    );
  }
}
