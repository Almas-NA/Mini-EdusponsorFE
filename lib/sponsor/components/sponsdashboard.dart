import 'package:edusponsor/sponsor/cubit/instwisesponsorships/sponssponsorships_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class SponsorDashboard extends StatefulWidget {
  const SponsorDashboard({super.key});

  @override
  State<SponsorDashboard> createState() => _SponsorDashboardState();
}

class _SponsorDashboardState extends State<SponsorDashboard> {
  Box box = Hive.box('eduSponsor');

  void _getSponsorships() {
    final body = {"sponsorId": box.get('userId')};
    context.read<SponssponsorshipsCubit>().getSponsSponsorships(body);
  }

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

  @override
  void initState() {
    super.initState();
    _getSponsorships();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SponssponsorshipsCubit, SponssponsorshipsState>(
        builder: (context, state) {
          if (state is SponssponsorshipsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SponssponsorshipsLoaded) {
            final sponsorships = state.sponsorships;

            if (sponsorships.isEmpty) {
              return const Center(child: Text("No sponsorships found"));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sponsorships.length,
              itemBuilder: (context, index) {
                final data = sponsorships[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 20),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ---------- Card Header with index ----------
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.cyan.shade700,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(14),
                          ),
                        ),
                        child: Text(
                          "Sponsorship #${index + 1}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ---------- Priority Banner ----------
                            Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      getPriorityColor(data['priority'] ?? ""),
                                      getPriorityColor(data['priority'] ?? "")
                                          .withOpacity(0.7),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "Priority: ${data['priority'] ?? 'N/A'}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // ---------- Year tiles ----------
                            _buildYearTile(
                              "1st Year",
                              data['yearOneFee'] ?? "0",
                              data['yearOneFeeStatus'] ?? "N/A",
                            ),
                            _buildYearTile(
                              "2nd Year",
                              data['yearTwoFee'] ?? "0",
                              data['yearTwoFeeStatus'] ?? "N/A",
                            ),
                            _buildYearTile(
                              "3rd Year",
                              data['yearThreeFee'] ?? "0",
                              data['yearThreeFeeStatus'] ?? "N/A",
                            ),
                            _buildYearTile(
                              "4th Year",
                              data['yearFourFee'] ?? "0",
                              data['yearFourFeeStatus'] ?? "N/A",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is SponssponsorshipsError) {
            return const Center(child: Text("Failed to load data"));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildYearTile(String year, String fee, String status) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.school, color: Colors.cyan),
        title: Text(
          "$year - ₹$fee",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: getStatusColor(status),
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
