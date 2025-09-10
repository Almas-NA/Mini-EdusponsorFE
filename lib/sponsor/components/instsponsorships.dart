import 'package:edusponsor/Common/loading_indicator%20copy.dart';
import 'package:edusponsor/config.dart';
import 'package:edusponsor/sponsor/cubit/instwisesponsorships/sponssponsorships_cubit.dart';
import 'package:edusponsor/sponsor/cubit/sponsorshipstatuscubit/sponsorshipstatus_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class SponsorInstSponsorships extends StatefulWidget {
  const SponsorInstSponsorships({super.key, required this.instID});

  final String instID;

  @override
  State<SponsorInstSponsorships> createState() =>
      _SponsorInstSponsorshipsState();
}

class _SponsorInstSponsorshipsState extends State<SponsorInstSponsorships> {
  Box box = Hive.box('eduSponsor');
  void _getSponsorships() {
    final body = {"institutionId": widget.instID};
    context.read<SponssponsorshipsCubit>().getInstitutionSponsorships(body);
  }

  ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: secondaryColor,
    foregroundColor: secondaryColor,
    padding: const EdgeInsets.symmetric(vertical: 14),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    elevation: 3,
  );

  @override
  void initState() {
    super.initState();
    _getSponsorships();
  }

  Color getStatusColor(String? status) {
    switch (status!.toLowerCase()) {
      case 'Paid':
        return Colors.green.shade400;
      case 'Rejected':
        return Colors.red.shade400;
      case 'Accepted':
        return const Color.fromARGB(255, 38, 60, 255);
      case 'requested':
        return const Color.fromARGB(255, 191, 80, 239);
      default:
        return Colors.grey.shade400;
    }
  }

  Color getPriorityColor(String? priority) {
    switch (priority?.toLowerCase()) {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Institution Sponsorships"),
        backgroundColor: Colors.cyan.shade600,
      ),
      body: BlocListener<SponsorshipstatusCubit, SponsorshipstatusState>(
        listener: (context, state) {
          if (state is SponsorshipstatusChanged) {
            _getSponsorships();
          }
        },
        child: BlocBuilder<SponssponsorshipsCubit, SponssponsorshipsState>(
          builder: (context, state) {
            if (state is SponssponsorshipsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SponssponsorshipsLoaded) {
              final sponsorships = state.sponsorships;

              if (sponsorships.isEmpty) {
                return const Center(child: Text("No sponsorships found."));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: sponsorships.length,
                itemBuilder: (context, index) {
                  final s = sponsorships[index];
                  String sponserID = s["sponsorId"] ?? "";
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: getPriorityColor(s['priority']),
                          child: Text(
                            s['priority'] != null
                                ? s['priority'][0].toUpperCase()
                                : "?",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          "Priority: ${s['priority'] ?? 'N/A'}",
                          style: TextStyle(
                            color: getPriorityColor(s['priority']),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        childrenPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        children: [
                          _buildYearTile(
                            "1st Year",
                            s['yearOneFee'],
                            s['yearOneFeeStatus'],
                          ),
                          _buildYearTile(
                            "2nd Year",
                            s['yearTwoFee'],
                            s['yearTwoFeeStatus'],
                          ),
                          _buildYearTile(
                            "3rd Year",
                            s['yearThreeFee'],
                            s['yearThreeFeeStatus'],
                          ),
                          _buildYearTile(
                            "4th Year",
                            s['yearFourFee'],
                            s['yearFourFeeStatus'],
                          ),

                          const SizedBox(height: 12),
                          (sponserID.isEmpty)
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child:
                                      BlocBuilder<
                                        SponsorshipstatusCubit,
                                        SponsorshipstatusState
                                      >(
                                        builder: (context, state) {
                                          if (state
                                              is SponsorshipstatusChanging) {
                                            return LoadingIndicator();
                                          } else {
                                            return ElevatedButton(
                                              style: buttonStyle,
                                              onPressed: () {
                                                Map body = {
                                                  "id": s['id'],
                                                  "sponsorId": box.get(
                                                    'userId',
                                                  ),
                                                };
                                                context
                                                    .read<
                                                      SponsorshipstatusCubit
                                                    >()
                                                    .getSponsorInfo(body);
                                              },
                                              child: const Text(
                                                "Sponsor",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    color: Colors.cyan.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.person,
                                      color: secondaryColor,
                                    ),
                                    title: const Text(
                                      "Sponsor Status",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text("Active"),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is SponssponsorshipsError) {
              return const Center(child: Text("No sponsorship requests Found"));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildYearTile(String year, String? fee, String? status) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: const Icon(Icons.school, color: Colors.cyan),
        title: Text(
          "$year - ₹${fee ?? '0'}",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: getStatusColor(status),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status ?? "N/A",
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
