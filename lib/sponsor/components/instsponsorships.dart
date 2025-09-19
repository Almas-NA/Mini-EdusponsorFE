import 'package:edusponsor/Common/enums/paymentresponse.dart';
import 'package:edusponsor/Common/loading_indicator%20copy.dart';
import 'package:edusponsor/Common/snack_bar.dart';
import 'package:edusponsor/Common/widgets.dart';
import 'package:edusponsor/config.dart';
import 'package:edusponsor/sponsor/cubit/instwisesponsorships/sponssponsorships_cubit.dart';
import 'package:edusponsor/sponsor/cubit/sponsorinfocubit/sponsorinfo_cubit.dart';
import 'package:edusponsor/sponsor/cubit/sponsorshipstatuscubit/sponsorshipstatus_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class SponsorInstSponsorships extends StatefulWidget {
  const SponsorInstSponsorships({super.key, required this.instID});

  final String instID;

  @override
  State<SponsorInstSponsorships> createState() =>
      _SponsorInstSponsorshipsState();
}

class _SponsorInstSponsorshipsState extends State<SponsorInstSponsorships> {
  Box box = Hive.box('eduSponsor');
  late Razorpay _razorpay;
  void _getSponsorships() {
    final body = {"institutionId": widget.instID};
    context.read<SponssponsorshipsCubit>().getInstitutionSponsorships(body);
  }

  String currentSponsorship = "";
  String currentYear = "";

  void _openCheckout(Map userDetails, String amount) {
    final int inr = int.tryParse(amount) ?? 0;
    if (inr <= 0) {
      displaySnackBar(message: "Give a valid amount");
      return;
    }

    // amount in paise
    final int amountPaise = inr * 100;

    var options = {
      'key': 'rzp_test_RJ2ya09RhfrpXB',
      'amount': amountPaise, // in paise
      'name': userDetails['username'] ?? "sponsor",
      'description': 'Scholorship payment',
      'prefill': {
        'contact': userDetails['contactNumber'] ?? "8888855555",
        'email': userDetails['email'] ?? "sponsor@gmail.com",
      },
      'theme': {'color': '#528FF0'},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error opening Razorpay: $e');
    }
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Map body = {
      "id": currentSponsorship,
      currentYear: PaymentResponse.PAID.name,
    };
    context.read<SponsorshipstatusCubit>().changeSponsorshipStatus(body, 0);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    displaySnackBar(message: "Payment is Failed");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('External wallet selected: ${response.walletName}'),
      ),
    );
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
    _getProfile();
    _razorpay = Razorpay();

    // Attach listeners
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
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

  void _getProfile() {
    Map body = {"id": box.get('userId')};
    context.read<SponsorinfoCubit>().getSponsorInfo(body);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SponsorinfoCubit, SponsorinfoState>(
      builder: (context, userstate) {
        if (userstate is SponsorinfoLoading) {
          return Scaffold(body: Center(child: LoadingIndicator()));
        } else if (userstate is SponsorinfoLoaded) {
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
                      return const Center(
                        child: Text("No sponsorships found."),
                      );
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
                                backgroundColor: getPriorityColor(
                                  s['priority'],
                                ),
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
                                  s['id'],
                                  'yearOneFeeStatus',
                                  userstate.sponsordetails,
                                ),
                                _buildYearTile(
                                  "2nd Year",
                                  s['yearTwoFee'],
                                  s['yearTwoFeeStatus'],
                                  s['id'],
                                  'yearTwoFeeStatus',
                                  userstate.sponsordetails,
                                ),
                                _buildYearTile(
                                  "3rd Year",
                                  s['yearThreeFee'],
                                  s['yearThreeFeeStatus'],
                                  s['id'],
                                  'yearThreeFeeStatus',
                                  userstate.sponsordetails,
                                ),
                                _buildYearTile(
                                  "4th Year",
                                  s['yearFourFee'],
                                  s['yearFourFeeStatus'],
                                  s['id'],
                                  "yearFourFeeStatus",
                                  userstate.sponsordetails,
                                ),

                                const SizedBox(height: 12),
                                (sponserID.isEmpty)
                                    ? Container(
                                        width: MediaQuery.of(
                                          context,
                                        ).size.width,
                                        decoration: BoxDecoration(
                                          color: secondaryColor,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
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
                                                          .changeSponsorshipStatus(
                                                            body,
                                                            1,
                                                          );
                                                    },
                                                    child: const Text(
                                                      "Sponsor",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
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
                    return const Center(
                      child: Text("No sponsorship requests Found"),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          );
        } else {
          return Scaffold(body: Center(child: Text("Error Occured")));
        }
      },
    );
  }

  Widget _buildYearTile(
    String year,
    String? fee,
    String? status,
    String sponsorshipID,
    String yearString,
    Map userDetail,
  ) {
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
        trailing: (status != null)
            ? GestureDetector(
                onTap: () {
                  if (status.isNotEmpty &&
                      status == PaymentResponse.REQUESTED.name) {
                    alertD(
                      context: context,
                      title: "Request",
                      content: "Institution requested to pay - ₹${fee ?? '0'}",
                      buttonText1: "Reject",
                      buttonText2: "Pay",
                      fn1: () async {
                        Map body = {
                          "id": sponsorshipID,
                          yearString: PaymentResponse.REJECTED.name,
                        };
                        context
                            .read<SponsorshipstatusCubit>()
                            .changeSponsorshipStatus(body, 0);
                        await Future.delayed(const Duration(seconds: 2));
                        Navigator.of(context).pop();
                      },
                      fn2: () {
                        setState(() {
                          currentSponsorship = sponsorshipID;
                          currentYear = yearString;
                        });
                        _openCheckout(userDetail, fee ?? "1000");
                      },
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: getStatusColor(status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    (status.isNotEmpty &&
                            status == PaymentResponse.REQUESTED.name)
                        ? "View Request"
                        : status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(), // nothing if status is null
      ),
    );
  }
}
