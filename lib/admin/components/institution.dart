import 'package:edusponsor/Common/loading_indicator%20copy.dart';
import 'package:edusponsor/admin/components/syncfusiongrid.dart';
import 'package:edusponsor/admin/cubits/institutions/allinstitutioncubit/allinstitution_cubit.dart';
import 'package:edusponsor/admin/cubits/institutions/institutioncubit/institutions_cubit.dart';
import 'package:edusponsor/admin/cubits/institutions/institutionstatus/institutionstatus_cubit.dart';
import 'package:edusponsor/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class AdminInstitutions extends StatefulWidget {
  const AdminInstitutions({super.key});

  @override
  State<AdminInstitutions> createState() => _AdminInstitutionsState();
}

class _AdminInstitutionsState extends State<AdminInstitutions> {
  late SFDataGridSourceInstitution sourceDataOfInstitutions;

  Widget columnHeading(String head) {
    return Text(
      textAlign: TextAlign.center,
      head,
      style: TextStyle(color: primaryColor),
    );
  }

  void _getInstitutions() {
    context.read<InstitutionsCubit>().getInstitutionsNotApproved();
    context.read<AllinstitutionCubit>().getAllInstitutions();
  }

  @override
  void initState() {
    _getInstitutions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: BlocListener<InstitutionstatusCubit, InstitutionstatusState>(
        listener: (context, state) {
          if (state is InstitutionsStatusChangeSuccess) {
            context.read<InstitutionsCubit>().getInstitutionsNotApproved();
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.05,
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                            "Institutions Pending for Approval",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      children: [
                        BlocBuilder<InstitutionsCubit, InstitutionsState>(
                          builder: (context, state) {
                            if (state is InstitutionsLoading) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: LoadingIndicator(),
                              );
                            }
                            if (state is InstitutionsLoaded) {
                              if (state.institutionNotApproved.isEmpty) {
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
                  
                              sourceDataOfInstitutions =
                                  SFDataGridSourceInstitution(
                                    context: context,
                                    dataSource: state.institutionNotApproved,
                                    tableName: "pendingInstitutions"
                                  );
                  
                              return Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(
                                  12,
                                ),
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
                                      source: sourceDataOfInstitutions,
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
                                          columnName: 'institutionName',
                                          minimumWidth: scalefactor > 1
                                              ? 200
                                              : 120,
                                          label: _buildHeader("Institution Name"),
                                        ),
                                        GridColumn(
                                          columnName: 'email',
                                          minimumWidth: scalefactor > 1
                                              ? 200
                                              : 150,
                                          label: _buildHeader("Email"),
                                        ),
                                        GridColumn(
                                          columnName: 'username',
                                          minimumWidth: scalefactor > 1
                                              ? 150
                                              : 100,
                                          label: _buildHeader("Username"),
                                        ),
                                        GridColumn(
                                          columnName: 'location',
                                          minimumWidth: scalefactor > 1
                                              ? 150
                                              : 100,
                                          label: _buildHeader("Location"),
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
                                    "Admin Institutions",
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
                            "Institutions",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      children: [
                        BlocBuilder<AllinstitutionCubit, AllinstitutionState>(
                          builder: (context, state) {
                            if (state is AllinstitutionLoading) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: LoadingIndicator(),
                              );
                            }
                            if (state is AllinstitutionLoaded) {
                              if (state.institutions.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    "No institutions pending approval.",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                );
                              }
                  
                              sourceDataOfInstitutions =
                                  SFDataGridSourceInstitution(
                                    context: context,
                                    dataSource: state.institutions,
                                    tableName: "allInstitutions"
                                  );
                  
                              return Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(
                                  12,
                                ),
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
                                      source: sourceDataOfInstitutions,
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
                                          columnName: 'institutionName',
                                          minimumWidth: scalefactor > 1
                                              ? 200
                                              : 120,
                                          label: _buildHeader("Institution Name"),
                                        ),
                                        GridColumn(
                                          columnName: 'institutionId',
                                          minimumWidth: scalefactor > 1
                                              ? 200
                                              : 120,
                                          label: _buildHeader("Institution ID"),
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
                                    "Admin Institutions",
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
