import 'package:edusponsor/Common/loading_indicator%20copy.dart';
import 'package:edusponsor/admin/cubits/dashboardcubit/dashboard_cubit.dart';
import 'package:edusponsor/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  void getInfo() {
    context.read<DashboardCubit>().getDashboardData();
  }

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const Center(child: LoadingIndicator());
            } else if (state is DashboardLoaded) {
              final dashboardData = state.dashboardInfo;
              return Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GridView.builder(
                        itemCount: dashboardData.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 6,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.2,
                        ),
                        itemBuilder: (context, index) {
                          final item = dashboardData[index];

                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryShade.withOpacity(0.3),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              gradient: LinearGradient(
                                colors: [secondaryShade, primaryShadeLight],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              child: InkWell(
                                onTap: () {},
                                borderRadius: BorderRadius.circular(20),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Icon and Title
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _getDashboardIcon(item['displayName']),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              item['displayName'],
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                letterSpacing: 1.2,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      // Total count in the center
                                      Center(
                                        child: Text(
                                          (item['total'] ?? "").toString(),
                                          style: const TextStyle(
                                            fontSize: 40,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      // Approved and Pending rows at the bottom
                                      _buildInfoRow(
                                        "Approved",
                                        item['approved'].toString(),
                                        valueColor: secondaryShadeLight,
                                      ),
                                      const SizedBox(height: 8),
                                      _buildInfoRow(
                                        "Pending",
                                        item['pending'].toString(),
                                        valueColor: Colors.redAccent,
                                      ),
                                    ],
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
              );
            } else {
              return const Center(child: Text("Error loading dashboard data"));
            }
          },
        ),
      ),
    );
  }

  Widget _getDashboardIcon(String displayName) {
    IconData iconData;
    switch (displayName) {
      case 'Students':
        iconData = Icons.school;
        break;
      case 'Sponsors':
        iconData = Icons.handshake;
        break;
      case 'Requests':
        iconData = Icons.description;
        break;
      case 'Scholarships':
        iconData = Icons.monetization_on;
        break;
      default:
        iconData = Icons.dashboard;
    }
    return Icon(
      iconData,
      size: 32,
      color: Colors.white,
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    Color valueColor = Colors.white,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              label == "Approved"
                  ? Icons.check_circle_outline
                  : Icons.pending_actions,
              color: label == "Approved" ? secondaryShadeLight : Colors.redAccent,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}