import 'package:edusponsor/student/cubit/dashboardcubit/studdashboard_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  Box box = Hive.box('eduSponsor');

  // ######## Status Colors ######## //
  Color getStatusColor(String status) {
    switch (status) {
      case 'PAID':
        return Colors.green.shade400;
      case 'REJECTED':
        return Colors.red.shade400;
      case 'ACCEPTED':
        return const Color.fromARGB(255, 38, 60, 255);
      case 'REQUESTED':
        return const Color.fromARGB(255, 191, 80, 239);
      default:
        return Colors.grey.shade400;
    }
  }

  Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red.shade400;
      case 'medium':
        return Colors.orange.shade400;
      case 'low':
        return Colors.green.shade400;
      default:
        return Colors.grey.shade400;
    }
  }

  void _getStudents() {
    Map body = {"studentId": box.get('refId')};
    context.read<StuddashboardCubit>().getSponsorshipStatus(body);
  }

  @override
  void initState() {
    _getStudents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<StuddashboardCubit, StuddashboardState>(
        builder: (context, state) {
          if (state is SponsorshipStatusLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SponsorshipStatusLoaded) {
            final sponsorshipDetail = state.sponsorshipStatus;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ######## Priority Banner ########
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            getPriorityColor(sponsorshipDetail['priority']),
                            getPriorityColor(
                              sponsorshipDetail['priority'],
                            ).withOpacity(0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        "Priority: ${sponsorshipDetail['priority'] ?? 'N/A'}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ######## Year Fee Cards ########
                  _buildYearCard(
                    "1st Year",
                    sponsorshipDetail['yearOneFee'] ?? "0",
                    sponsorshipDetail['yearOneFeeStatus'] ?? "N/A",
                    getStatusColor(
                      sponsorshipDetail['yearOneFeeStatus'] ?? "N/A",
                    ),
                  ),
                  _buildYearCard(
                    "2nd Year",
                    sponsorshipDetail['yearTwoFee'] ?? "0",
                    sponsorshipDetail['yearTwoFeeStatus'] ?? "N/A",
                    getStatusColor(
                      sponsorshipDetail['yearTwoFeeStatus'] ?? "N/A",
                    ),
                  ),
                  _buildYearCard(
                    "3rd Year",
                    sponsorshipDetail['yearThreeFee'] ?? "0",
                    sponsorshipDetail['yearThreeFeeStatus'] ?? "N/A",
                    getStatusColor(
                      sponsorshipDetail['yearThreeFeeStatus'] ?? "N/A",
                    ),
                  ),
                  _buildYearCard(
                    "4th Year",
                    sponsorshipDetail['yearFourFee'] ?? "0",
                    sponsorshipDetail['yearFourFeeStatus'] ?? "N/A",
                    getStatusColor(
                      sponsorshipDetail['yearFourFeeStatus'] ?? "N/A",
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ######## Sponsor Info Card ########
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.cyan.shade50,
                    child: ListTile(
                      leading: const Icon(Icons.person, color: Colors.cyan),
                      title: const Text(
                        "Sponsor ID",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        sponsorshipDetail['sponsorId'] ?? "Unknown",
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is SponsorshipStatusError) {
            return const Center(child: Text("Failed to load data"));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildYearCard(
    String year,
    String fee,
    String status,
    Color statusColor,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        leading: const Icon(Icons.school, color: Colors.cyan),
        title: Text(
          "$year - ₹$fee",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
