import 'package:edusponsor/Common/loading_indicator%20copy.dart';
import 'package:edusponsor/admin/cubits/institutions/institutionstatus/institutionstatus_cubit.dart';
import 'package:edusponsor/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SFDataGridSourceInstitution extends DataGridSource {
  SFDataGridSourceInstitution({
    required List<dynamic> dataSource,
    required BuildContext context,
    required String tableName,
  }) {
    _dataSource = dataSource;
    _context = context;
    _tableName = tableName;
    _dataGridRows = _buildDataGridRows(_dataSource);
  }

  List<dynamic> _dataSource = [];
  late List<DataGridRow> _dataGridRows;
  late BuildContext _context;
  late String _tableName;
  List<dynamic> get dataSource => _dataSource;

  List<DataGridRow> _buildDataGridRows(List<dynamic> dataSource) {
    return dataSource.asMap().entries.map<DataGridRow>((entry) {
      var dataGridRow = entry.value;
      int index = entry.key;
      if (_tableName == "pendingInstitutions") {
        return DataGridRow(
          cells: [
            DataGridCell<String>(
              columnName: 'slno',
              value: (index + 1).toString(),
            ),
            DataGridCell<String>(
              columnName: 'institutionName',
              value: (dataGridRow['instituteName'] ?? "").toString(),
            ),
            DataGridCell<String>(
              columnName: 'email',
              value: (dataGridRow['email'] ?? "").toString(),
            ),
            DataGridCell<String>(
              columnName: 'username',
              value: (dataGridRow['username'] ?? "").toString(),
            ),
            DataGridCell<String>(
              columnName: 'location',
              value: (dataGridRow['location'] ?? "").toString(),
            ),
            DataGridCell<String>(
              columnName: 'approve',
              value: (dataGridRow[''] ?? "").toString(),
            ),
            DataGridCell<String>(
              columnName: 'reject',
              value: (dataGridRow[''] ?? "").toString(),
            ),
          ],
        );
      } else {
        return DataGridRow(
          cells: [
            DataGridCell<String>(
              columnName: 'slno',
              value: (index + 1).toString(),
            ),
            DataGridCell<String>(
              columnName: 'institutionName',
              value: (dataGridRow['instituteName'] ?? "").toString(),
            ),
            DataGridCell<String>(
              columnName: 'institutionId',
              value: (dataGridRow['instituteId'] ?? "").toString(),
            ),
            DataGridCell<String>(
              columnName: 'email',
              value: (dataGridRow['email'] ?? "").toString(),
            ),
            DataGridCell<String>(
              columnName: 'location',
              value: (dataGridRow['location'] ?? "").toString(),
            ),
          ],
        );
      }
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    int rowIndex = _dataGridRows.indexOf(row);
    final rowData = _dataSource[rowIndex];
    return DataGridRowAdapter(
      color: rowIndex % 2 == 0
          ? Colors.white
          : const Color.fromARGB(255, 249, 247, 247),
      cells: row.getCells().map<Widget>((dataGridCell) {
        if (dataGridCell.columnName == 'approve') {
          return Theme(
            data: Theme.of(_context).copyWith(
              popupMenuTheme: PopupMenuThemeData(
                color: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 8,
              ),
            ),
            child: Center(
              child:
                  BlocBuilder<InstitutionstatusCubit, InstitutionstatusState>(
                    builder: (context, state) {
                      if (state is InstitutionsStatusChangeLoading &&
                          rowIndex == state.index &&
                          dataGridCell.columnName == state.button) {
                        return LoadingIndicator();
                      }
                      return ElevatedButton(
                        onPressed: () {
                          _context
                              .read<InstitutionstatusCubit>()
                              .approveInstitution(
                                {
                                  "id": rowData['id'],
                                  "username": rowData['username'],
                                  "password": rowData['password'],
                                },
                                rowIndex,
                                dataGridCell.columnName,
                              );
                        },
                        child: Text("Approve"),
                      );
                    },
                  ),
            ),
          );
        } else if (dataGridCell.columnName == 'reject') {
          return Theme(
            data: Theme.of(_context).copyWith(
              popupMenuTheme: PopupMenuThemeData(
                color: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 8,
              ),
            ),
            child: Center(
              child:
                  BlocBuilder<InstitutionstatusCubit, InstitutionstatusState>(
                    builder: (context, state) {
                      if (state is InstitutionsStatusChangeLoading &&
                          rowIndex == state.index &&
                          dataGridCell.columnName == state.button) {
                        return LoadingIndicator();
                      }
                      return ElevatedButton(
                        onPressed: () {
                          _context
                              .read<InstitutionstatusCubit>()
                              .rejectInstitution(
                                {"id": rowData['id']},
                                rowIndex,
                                dataGridCell.columnName,
                              );
                        },
                        child: Text("Reject"),
                      );
                    },
                  ),
            ),
          );
        } else {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              (dataGridCell.value ?? "").toString(),
              style: TextStyle(
                color: getColor((dataGridCell.value ?? "").toString()),
              ),
            ),
          );
        }
      }).toList(),
    );
  }

  Color getColor(String value) {
    if (value == 'CART') {
      return Colors.orange;
    } else if (value == 'ORDER') {
      return Colors.black;
    } else if (value == 'DELIVERED') {
      return Colors.green;
    } else if (value == 'CANCELED') {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }
}
