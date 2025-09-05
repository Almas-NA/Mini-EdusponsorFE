import 'dart:convert';
import 'dart:typed_data';

import 'package:edusponsor/Common/loading_indicator%20copy.dart';
import 'package:edusponsor/admin/cubits/sponsors/sponsorstatus/sponsorstatus_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdfx/pdfx.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SFDataGridSourceSponsors extends DataGridSource {
  SFDataGridSourceSponsors({
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

      if (_tableName == "pendingSponsors") {
        return DataGridRow(
          cells: [
            DataGridCell<String>(
              columnName: 'slno',
              value: (index + 1).toString(),
            ),
            DataGridCell<String>(
              columnName: 'fullName',
              value: (dataGridRow['username'] ?? "").toString(),
            ),
            DataGridCell<String>(
              columnName: 'email',
              value: (dataGridRow['email'] ?? "").toString(),
            ),
            DataGridCell<String>(
              columnName: 'location',
              value: (dataGridRow['location'] ?? "").toString(),
            ),
            DataGridCell<String>(
              columnName: 'incomeProof',
              value: (dataGridRow['incomeProofBaseSF'] ?? "").toString(),
            ),
            DataGridCell<String>(columnName: 'approve', value: ""),
            DataGridCell<String>(columnName: 'reject', value: ""),
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
              columnName: 'sponsorName',
              value: (dataGridRow['username'] ?? "").toString(),
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
          return Center(
            child: BlocBuilder<SponsorstatusCubit, SponsorstatusState>(
              builder: (context, state) {
                if (state is SponsorstatusLoading &&
                    rowIndex == state.index &&
                    dataGridCell.columnName == state.button) {
                  return LoadingIndicator();
                }
                return ElevatedButton(
                  onPressed: () {
                    _context.read<SponsorstatusCubit>().approveSponsor(
                      {
                        "id": rowData['id'],
                        "username": rowData['username'],
                        "password": rowData['password'],
                      },
                      rowIndex,
                      dataGridCell.columnName,
                    );
                  },
                  child: const Text("Approve"),
                );
              },
            ),
          );
        } else if (dataGridCell.columnName == 'reject') {
          return Center(
            child: BlocBuilder<SponsorstatusCubit, SponsorstatusState>(
              builder: (context, state) {
                if (state is SponsorstatusLoading &&
                    rowIndex == state.index &&
                    dataGridCell.columnName == state.button) {
                  return LoadingIndicator();
                }
                return ElevatedButton(
                  onPressed: () {
                    _context.read<SponsorstatusCubit>().rejectSponsor(
                      {"id": rowData['id']},
                      rowIndex,
                      dataGridCell.columnName,
                    );
                  },
                  child: const Text("Reject"),
                );
              },
            ),
          );
        } else if (dataGridCell.columnName == 'incomeProof') {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                showIncomeProofDialog(_context, dataGridCell.value ?? "");
              },
              child: const Text("View PDF"),
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

  void showIncomeProofDialog(BuildContext context, String base64) {
  String cleanBase64 = base64.split(',').last;
  if (cleanBase64.isEmpty) {
    print("Error: The base64 string for the PDF is empty or invalid.");
    return;
  }

  Uint8List pdfBytes;
  try {
    pdfBytes = base64Decode(cleanBase64);
  } catch (e) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: const Text('Failed to load the PDF.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    return;
  }

  if (pdfBytes.isEmpty) {
    print("Error: Decoded PDF bytes are empty.");
    return;
  }

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      final pdfController = PdfController(
        document: PdfDocument.openData(pdfBytes),
      );

      return AlertDialog(
        insetPadding: const EdgeInsets.all(16.0),
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(width: 1.0, color: Colors.grey),
        ),
        backgroundColor: Colors.white,
        elevation: 3.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Income Proof'),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        content: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width * 0.7,
          child: PdfView(
            controller: pdfController,
            scrollDirection: Axis.vertical,
            onPageChanged: (page) {
              print('Page changed: $page');
            },
          ),
        ),
      );
    },
  );
}

}
