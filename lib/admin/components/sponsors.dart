import 'package:edusponsor/Common/loading_indicator%20copy.dart';
import 'package:edusponsor/admin/components/sfgridsponsors.dart';
import 'package:edusponsor/admin/cubits/sponsors/allsponsorcubit/allsponsorcubit_cubit.dart';
import 'package:edusponsor/admin/cubits/sponsors/sponsorcubit/sponsor_cubit.dart';
import 'package:edusponsor/admin/cubits/sponsors/sponsorstatus/sponsorstatus_cubit.dart';
import 'package:edusponsor/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class AdminSponsors extends StatefulWidget {
  const AdminSponsors({super.key});

  @override
  State<AdminSponsors> createState() => _AdminSponsorsState();
}

class _AdminSponsorsState extends State<AdminSponsors> {
  late SFDataGridSourceSponsors sourceDataOfSponsors;

  Widget columnHeading(String head) {
    return Text(
      textAlign: TextAlign.center,
      head,
      style: TextStyle(color: primaryColor),
    );
  }

  void _getSponsors() {
    context.read<AllsponsorcubitCubit>().getAllSponsors();
    context.read<SponsorCubit>().getSponsorsNotApproved();
  }

  @override
  void initState() {
    _getSponsors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SponsorstatusCubit, SponsorstatusState>(
        listener: (context, state) {
          if (state is SponsorstatusSuccess) {
            _getSponsors();
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: secondaryColor!, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    backgroundColor: Colors.transparent,
                    collapsedBackgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tilePadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    title: Row(
                      children: [
                        const Icon(
                          Icons.approval,
                          color: Colors.white,
                          size: 26,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Sponsors Pending for Approval",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    children: [
                      BlocBuilder<SponsorCubit, SponsorState>(
                        builder: (context, state) {
                          if (state is SponsorLoading) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: LoadingIndicator(),
                            );
                          }
                          if (state is SponsorLoaded) {
                            if (state.sponsors.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  "No institutions pending for approval.",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              );
                            }

                            sourceDataOfSponsors = SFDataGridSourceSponsors(
                              context: context,
                              dataSource: state.sponsors,
                              tableName: "pendingSponsors",
                            );

                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: SfDataGridTheme(
                                  data: SfDataGridThemeData(
                                    headerColor: Colors.blueGrey.shade50,
                                    gridLineColor: Colors.grey.shade300
                                        .withOpacity(0.8),
                                    rowHoverColor: primaryShadeLight,
                                  ),
                                  child: SfDataGrid(
                                    footerFrozenRowsCount: 1,
                                    allowSorting: false,
                                    frozenColumnsCount: 1,
                                    source: sourceDataOfSponsors,
                                    // columnWidthMode: ColumnWidthMode.fitByColumnName,
                                    gridLinesVisibility:
                                        GridLinesVisibility.horizontal,
                                    headerRowHeight:
                                        MediaQuery.of(context).size.height *
                                        0.06,
                                    rowHeight:
                                        MediaQuery.of(context).size.height *
                                        0.055,
                                    columns: <GridColumn>[
                                      GridColumn(
                                        columnName: 'slno',
                                        minimumWidth: scalefactor > 1
                                            ? 150
                                            : 70,
                                        label: _buildHeader("Sl No"),
                                      ),
                                      GridColumn(
                                        columnName: 'fullName',
                                        minimumWidth: scalefactor > 1
                                            ? 200
                                            : 120,
                                        label: _buildHeader("Sponsor Name"),
                                      ),
                                      GridColumn(
                                        columnName: 'email',
                                        minimumWidth: scalefactor > 1
                                            ? 200
                                            : 150,
                                        label: _buildHeader("Email"),
                                      ),
                                      GridColumn(
                                        columnName: 'location',
                                        minimumWidth: scalefactor > 1
                                            ? 150
                                            : 100,
                                        label: _buildHeader("Location"),
                                      ),
                                      GridColumn(
                                        columnName: 'incomeProof',
                                        minimumWidth: scalefactor > 1
                                            ? 150
                                            : 100,
                                        label: _buildHeader("Income Proof"),
                                      ),
                                      GridColumn(
                                        columnName: 'approve',
                                        minimumWidth: scalefactor > 1
                                            ? 150
                                            : 100,
                                        label: _buildHeader("Approve"),
                                      ),
                                      GridColumn(
                                        columnName: 'reject',
                                        minimumWidth: scalefactor > 1
                                            ? 150
                                            : 100,
                                        label: _buildHeader("Reject"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  "Admin Sponsors",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: secondaryColor!, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    backgroundColor: Colors.transparent,
                    collapsedBackgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tilePadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    title: Row(
                      children: [
                        const Icon(
                          Icons.approval,
                          color: Colors.white,
                          size: 26,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "All Sponsors",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    children: [
                      BlocBuilder<AllsponsorcubitCubit, AllsponsorcubitState>(
                        builder: (context, state) {
                          if (state is AllsponsorcubitLoading) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: LoadingIndicator(),
                            );
                          }
                          if (state is AllsponsorcubitLoaded) {
                            sourceDataOfSponsors = SFDataGridSourceSponsors(
                              context: context,
                              dataSource: state.sponsors,
                              tableName: "allSponsors",
                            );

                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: SfDataGridTheme(
                                  data: SfDataGridThemeData(
                                    headerColor: Colors.blueGrey.shade50,
                                    gridLineColor: Colors.grey.shade300
                                        .withOpacity(0.8),
                                    rowHoverColor: primaryShadeLight,
                                  ),
                                  child: SfDataGrid(
                                    footerFrozenRowsCount: 1,
                                    allowSorting: false,
                                    frozenColumnsCount: 1,
                                    source: sourceDataOfSponsors,
                                    columnWidthMode:
                                        ColumnWidthMode.fitByCellValue,
                                    gridLinesVisibility:
                                        GridLinesVisibility.horizontal,
                                    headerRowHeight:
                                        MediaQuery.of(context).size.height *
                                        0.06,
                                    rowHeight:
                                        MediaQuery.of(context).size.height *
                                        0.055,
                                    columns: <GridColumn>[
                                      GridColumn(
                                        columnName: 'slno',
                                        minimumWidth: scalefactor > 1
                                            ? 150
                                            : 70,
                                        label: _buildHeader("Sl No"),
                                      ),
                                      GridColumn(
                                        columnName: 'sponsorName',
                                        minimumWidth: scalefactor > 1
                                            ? 200
                                            : 120,
                                        label: _buildHeader("Sponsor Name"),
                                      ),
                                      GridColumn(
                                        columnName: 'email',
                                        minimumWidth: scalefactor > 1
                                            ? 200
                                            : 150,
                                        label: _buildHeader("Email"),
                                      ),
                                      GridColumn(
                                        columnName: 'location',
                                        minimumWidth: scalefactor > 1
                                            ? 150
                                            : 100,
                                        label: _buildHeader("Location"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  "Admin Sponsors",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
