import 'dart:convert';
import 'dart:typed_data';

import 'package:edusponsor/Common/enums/response_type_enum.dart';
import 'package:edusponsor/Common/inputdecoration.dart';
import 'package:edusponsor/Common/network/dio_fetch_api.dart';
import 'package:edusponsor/Common/widgets.dart';
import 'package:edusponsor/config.dart';
import 'package:edusponsor/institution/cubit/studentcubit/student_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:pdfx/pdfx.dart';

class InstitutionDashboard extends StatefulWidget {
  const InstitutionDashboard({super.key});

  @override
  State<InstitutionDashboard> createState() => _InstitutionDashboardState();
}

class _InstitutionDashboardState extends State<InstitutionDashboard> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _studentEmailController = TextEditingController();
  final TextEditingController _studentContactController =
      TextEditingController();
  final TextEditingController _parentEmailController = TextEditingController();
  final TextEditingController _parentContactController =
      TextEditingController();
  final TextEditingController _incomeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _selectedYear;
  final List<String> _years = ['1st Year', '2nd Year', '3rd Year', '4th Year'];
  Box box = Hive.box('eduSponsor');
  ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryShadeLight,
    foregroundColor: primaryShadeLight,
    padding: const EdgeInsets.symmetric(vertical: 14),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    elevation: 3,
  );

  String? selectedYear;
  String searchQuery = "";

  void _getStudents() {
    Map body = {"id": box.get('userId')};
    context.read<StudentCubit>().getStudents(body);
  }

  @override
  void initState() {
    _getStudents();
    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: BlocConsumer<StudentCubit, StudentState>(
        listener: (context, state) {
          if (state is StudentUpdateSuccess ||
              state is StudentDeleteSuccess ||
              state is StudentUpdateError ||
              state is StudentDeleteError ||
              state is StudentAddYearFeesSuccess ||
              state is StudentAddYearFeesError) {
            _getStudents();
          }
        },
        builder: (context, state) {
          if (state is StudentGetLoading ||
              state is StudentDeleteLoading ||
              state is StudentUpdateLoading ||
              state is StudentAddYearFeesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is StudentGetError) {
            return const Center(child: Text("Failed to load students"));
          } else if (state is StudentGetSuccess) {
            final students = state.institutionStudents;

            if (students.isEmpty) {
              return const Center(child: Text("No students found"));
            }
            final years = students
                .map((s) => s['year'] as String)
                .toSet()
                .toList();
            final filteredStudents = students.where((s) {
              final matchesYear =
                  selectedYear == null || s['year'] == selectedYear;
              final matchesSearch =
                  searchQuery.isEmpty ||
                  "${s['firstName']} ${s['secondName']}".toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  );
              return matchesYear && matchesSearch;
            }).toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
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
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.clear,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          searchQuery = "";
                                          _searchController.clear();
                                        });
                                      },
                                    )
                                  : null,
                              hintText: "Search by name...",
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                            onChanged: (val) {
                              setState(() => searchQuery = val);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 150,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: selectedYear,
                              hint: const Text("Select Year"),
                              items: years.map((year) {
                                return DropdownMenuItem(
                                  value: year,
                                  child: Text(year),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedYear = value;
                                });
                              },
                            ),
                          ),
                        ),

                        if (selectedYear != null)
                          IconButton(
                            icon: const Icon(Icons.clear, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                selectedYear = null;
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: filteredStudents.length,
                    itemBuilder: (context, index) {
                      final student = filteredStudents[index];
                      return _buildStudentCard(student, index);
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildStudentCard(Map student, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
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
            leading: CircleAvatar(
              radius: 26,
              backgroundColor: Colors.cyan.shade400,
              child: Text(
                student['firstName'][0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            title: Text(
              "${student['firstName']} ${student['secondName']}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(
              student['department'] ?? "",
              style: TextStyle(color: Colors.grey.shade600),
            ),
            childrenPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
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
                child: Column(
                  children: [
                    // Grid-like details
                    _buildDetailGrid([
                      [Icons.email, "Email", student['studentEmail']],
                      [Icons.phone, "Contact", student['studentContact']],
                      [Icons.school, "Year", student['year']],
                      [Icons.person, "Parent", student['parentName']],
                      [
                        Icons.email_outlined,
                        "Parent Email",
                        student['parentEmail'],
                      ],
                      [
                        Icons.phone_android,
                        "Parent Contact",
                        student['parentContact'],
                      ],
                      [Icons.family_restroom, "Relation", student['relation']],
                      [
                        Icons.currency_rupee,
                        "Annual Income",
                        student['annualIncome'].toString(),
                      ],
                      if (student['incomeProofBaseSF'] != null &&
                          student['incomeProofBaseSF'].isNotEmpty)
                        [
                          Icons.picture_as_pdf,
                          "Income Proof",
                          () => showIncomeProofDialog(
                            context,
                            student['incomeProofBaseSF'],
                          ),
                          true, // 👈 mark this row as action
                        ],
                    ]),
                  ],
                ),
              ),
              if (student['incomeProofBaseSF'] != null &&
                  student['incomeProofBaseSF'].isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      showIncomeProofDialog(
                        context,
                        student['incomeProofBaseSF'],
                      );
                    },
                    icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                    label: const Text(
                      "View Income Proof",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: ElevatedButton(
                        style: buttonStyle,
                        onPressed: () {
                          context.read<StudentCubit>().deleteStudent({
                            "id": student['id'],
                          });
                        },
                        child: const Text(
                          "Delete",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: ElevatedButton(
                        style: buttonStyle,
                        onPressed: () {
                          updateStudentDialog(student);
                        },
                        child: const Text(
                          "Update",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: ElevatedButton(
                        style: buttonStyle,
                        onPressed: () async {
                          final response = await FetchApi.postData(
                            endPoint: 'institution/check/sponsorship/exists',
                            body: {"studentId": student['id']},
                          );
                          if (response?['type'] ==
                              ServerResponseType.SUCCESS.name) {
                            showSponsorshipDetailsDialog(
                              response['responseData']['data'][0] ?? {},
                            );
                          } else {
                            addYearFeesDialog(student);
                          }
                        },
                        child: const Text(
                          "Add Sponsorship",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailGrid(List<List<dynamic>> details) {
    return Column(
      children: details.map((d) {
        final isAction = d.length > 3 && d[3] == true; // mark special rows

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(d[0], size: 18, color: Colors.cyan),
              const SizedBox(width: 10),
              Expanded(
                flex: 8,
                child: Text(
                  "${d[1]}:",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                flex: 2,
                child: isAction
                    ? ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 1,
                        ),
                        onPressed: () => d[2](),
                        icon: const Icon(Icons.picture_as_pdf, size: 16),
                        label: const Text(
                          "View",
                          style: TextStyle(fontSize: 13),
                        ),
                      )
                    : Text(
                        d[2] ?? "-",
                        textAlign: TextAlign.left,
                        style: const TextStyle(color: Colors.black87),
                      ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void updateStudentDialog(Map studentDetail) {
    _studentEmailController.text = studentDetail['studentEmail'] ?? "";
    _studentContactController.text = studentDetail['studentContact'] ?? "";
    _parentEmailController.text = studentDetail['parentEmail'] ?? "";
    _parentContactController.text = studentDetail['parentContact'] ?? "";
    _incomeController.text = studentDetail['annualIncome'] ?? "";
    _selectedYear = studentDetail['year'];
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
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
              const Text('Update Student'),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width * 0.7,
            child: Card(
              color: secondaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 5,
              shadowColor: Colors.blueAccent.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: getInputDecoration("Year").copyWith(
                          prefixIcon: const Icon(Icons.calendar_month),
                        ),
                        items: _years
                            .map(
                              (year) => DropdownMenuItem(
                                value: year,
                                child: Text(year),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _selectedYear = value),
                        validator: (value) =>
                            value == null ? "Select year" : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _studentEmailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: getInputDecoration(
                          "Student Email",
                        ).copyWith(prefixIcon: const Icon(Icons.email)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter student email";
                          }
                          final emailRegex = RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          );
                          if (!emailRegex.hasMatch(value)) {
                            return "Enter valid email";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _studentContactController,
                        keyboardType: TextInputType.phone,
                        decoration: getInputDecoration(
                          "Student Contact Number",
                        ).copyWith(prefixIcon: const Icon(Icons.phone_android)),
                        validator: (value) =>
                            value!.isEmpty ? "Enter contact number" : null,
                      ),
                      const SizedBox(height: 25),
                      TextFormField(
                        controller: _parentEmailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: getInputDecoration("Parent Email").copyWith(
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter parent email";
                          }
                          final emailRegex = RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          );
                          if (!emailRegex.hasMatch(value)) {
                            return "Enter valid email";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _parentContactController,
                        keyboardType: TextInputType.phone,
                        decoration: getInputDecoration(
                          "Parent Contact Number",
                        ).copyWith(prefixIcon: const Icon(Icons.phone)),
                        validator: (value) =>
                            value!.isEmpty ? "Enter contact number" : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _incomeController,
                        keyboardType: TextInputType.number,
                        decoration: getInputDecoration("Annual Income")
                            .copyWith(
                              prefixIcon: const Icon(Icons.currency_rupee),
                            ),
                        validator: (value) =>
                            value!.isEmpty ? "Enter annual income" : null,
                      ),

                      const SizedBox(height: 30),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryShadeLight,
                              foregroundColor: primaryShadeLight,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              elevation: 3,
                            ),
                            onPressed: () {
                              alertD(
                                context: context,
                                title: "Warning",
                                content: "Confirm to Update this student?",
                                buttonText1: "No",
                                buttonText2: "Yes",
                                fn1: () {
                                  Navigator.of(context).pop();
                                },
                                fn2: () {
                                  if (_formKey.currentState!.validate()) {
                                    final studentData = {
                                      "id": studentDetail['id'],
                                      "year": _selectedYear,
                                      "studentEmail":
                                          _studentEmailController.text,
                                      "studentContact":
                                          _studentContactController.text,
                                      "parentEmail":
                                          _parentEmailController.text,
                                      "parentContact":
                                          _parentContactController.text,
                                      "annualIncome": _incomeController.text,
                                    };
                                    context.read<StudentCubit>().updateStudent(
                                      studentData,
                                    );
                                    Navigator.of(context).pop();
                                  }
                                },
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: const Text(
                                "Update",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void addYearFeesDialog(Map studentDetail) {
    final TextEditingController yearOneFeeController = TextEditingController();
    final TextEditingController yearTwoFeeController = TextEditingController();
    final TextEditingController yearThreeFeeController =
        TextEditingController();
    final TextEditingController yearFourFeeController = TextEditingController();
    String? selectedPriority;
    final GlobalKey<FormState> _feesFormKey = GlobalKey<FormState>();

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
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
              const Text('Add Year Fees'),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.6,
            child: Card(
              color: secondaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 5,
              shadowColor: Colors.blueAccent.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _feesFormKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: yearOneFeeController,
                          keyboardType: TextInputType.number,
                          decoration: getInputDecoration("1st Year Fee")
                              .copyWith(
                                prefixIcon: const Icon(Icons.currency_rupee),
                              ),
                          validator: (value) =>
                              value!.isEmpty ? "Enter 1st year fee" : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: yearTwoFeeController,
                          keyboardType: TextInputType.number,
                          decoration: getInputDecoration("2nd Year Fee")
                              .copyWith(
                                prefixIcon: const Icon(Icons.currency_rupee),
                              ),
                          validator: (value) =>
                              value!.isEmpty ? "Enter 2nd year fee" : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: yearThreeFeeController,
                          keyboardType: TextInputType.number,
                          decoration: getInputDecoration("3rd Year Fee")
                              .copyWith(
                                prefixIcon: const Icon(Icons.currency_rupee),
                              ),
                          validator: (value) =>
                              value!.isEmpty ? "Enter 3rd year fee" : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: yearFourFeeController,
                          keyboardType: TextInputType.number,
                          decoration: getInputDecoration("4th Year Fee")
                              .copyWith(
                                prefixIcon: const Icon(Icons.currency_rupee),
                              ),
                          validator: (value) =>
                              value!.isEmpty ? "Enter 4th year fee" : null,
                        ),
                        const SizedBox(height: 12),

                        // Priority dropdown
                        DropdownButtonFormField<String>(
                          value: selectedPriority,
                          decoration: getInputDecoration(
                            "Priority",
                          ).copyWith(prefixIcon: const Icon(Icons.star)),
                          items: ["High", "Medium", "Low"]
                              .map(
                                (priority) => DropdownMenuItem(
                                  value: priority,
                                  child: Text(priority),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            selectedPriority = value;
                          },
                          validator: (value) =>
                              value == null ? "Select priority" : null,
                        ),

                        const SizedBox(height: 25),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryShadeLight,
                              foregroundColor: primaryShadeLight,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              elevation: 3,
                            ),
                            onPressed: () {
                              if (_feesFormKey.currentState!.validate()) {
                                final feesData = {
                                  "institutionId": box.get('userId'),
                                  "studentId": studentDetail['id'],
                                  "yearOneFee": yearOneFeeController.text,
                                  "yearTwoFee": yearTwoFeeController.text,
                                  "yearThreeFee": yearThreeFeeController.text,
                                  "yearFourFee": yearFourFeeController.text,
                                  "priority": selectedPriority,
                                };
                                context.read<StudentCubit>().createSponsorship(
                                  feesData,
                                );
                                Navigator.of(context).pop();
                              }
                            },
                            child: const Text(
                              "Save Fees",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showSponsorshipDetailsDialog(Map sponsorshipDetail) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        Color getStatusColor(String status) {
          switch (status.toLowerCase()) {
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

        return AlertDialog(
          insetPadding: const EdgeInsets.all(16.0),
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(width: 1.0, color: Colors.grey),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Sponsorship Details',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
            width: MediaQuery.of(context).size.width * 0.6,
            child: Card(
              color: secondaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Priority Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              getPriorityColor(
                                sponsorshipDetail['priority'] ?? "",
                              ),
                              getPriorityColor(
                                sponsorshipDetail['priority'] ?? "",
                              ).withOpacity(0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          "Priority: ${sponsorshipDetail['priority'] ?? "N/A"}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Year Cards
                      _buildYearCard(
                        "1st Year",
                        sponsorshipDetail['yearOneFee'] ?? "-",
                        sponsorshipDetail['yearOneFeeStatus'] ?? "-",
                        getStatusColor(
                          sponsorshipDetail['yearOneFeeStatus'] ?? "",
                        ),
                        (sponsorshipDetail['sponsorId'] != "") ? true : false,
                        true
                      ),
                      _buildYearCard(
                        "2nd Year",
                        sponsorshipDetail['yearTwoFee'] ?? "-",
                        sponsorshipDetail['yearTwoFeeStatus'] ?? "-",
                        getStatusColor(
                          sponsorshipDetail['yearTwoFeeStatus'] ?? "",
                        ),
                        (sponsorshipDetail['sponsorId'] != "") ? true : false,
                        (sponsorshipDetail['yearOneFeeStatus']=="paid")?true:false
                      ),
                      _buildYearCard(
                        "3rd Year",
                        sponsorshipDetail['yearThreeFee'] ?? "-",
                        sponsorshipDetail['yearThreeFeeStatus'] ?? "-",
                        getStatusColor(
                          sponsorshipDetail['yearThreeFeeStatus'] ?? "",
                        ),
                        (sponsorshipDetail['sponsorId'] != "") ? true : false,
                        (sponsorshipDetail['yearTwoFeeStatus']=="paid")?true:false
                      ),
                      _buildYearCard(
                        "4th Year",
                        sponsorshipDetail['yearFourFee'] ?? "-",
                        sponsorshipDetail['yearFourFeeStatus'] ?? "-",
                        getStatusColor(
                          sponsorshipDetail['yearFourFeeStatus'] ?? "",
                        ),
                        (sponsorshipDetail['sponsorId'] != "") ? true : false,
                        (sponsorshipDetail['yearThreeFeeStatus']=="paid")?true:false
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.cyan.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.person, color: secondaryColor),
                          title: const Text(
                            "Sponsor Status",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            (sponsorshipDetail['sponsorId'] != "")
                                ? "Active"
                                : "Not active",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildYearCard(
    String year,
    String fee,
    String status,
    Color statusColor,
    bool isSponsorActive,
    bool isCardActive,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        leading: const Icon(Icons.school, color: Colors.cyan),
        title: Text("$year - ₹$fee"),
        trailing:
        //  (isSponsorActive&&isCardActive)
        //     ? AbsorbPointer(
        //       absorbing: !isCardActive,
        //       child: SizedBox(
        //         width: MediaQuery.of(context).size.width*0.1,
        //         child: ElevatedButton(
        //             style: ElevatedButton.styleFrom(
        //               backgroundColor: (!isCardActive)?Colors.grey:primaryShadeLight,
        //               foregroundColor: (!isCardActive)?Colors.grey:primaryShadeLight,
        //               padding: const EdgeInsets.symmetric(vertical: 14),
        //               shape: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(12),
        //               ),
        //               elevation: 3,
        //             ),
        //             onPressed: () {},
        //             child: Text("Request",style: TextStyle(color: Colors.black),),
        //           ),
        //       ),
        //     )
        //     : 
            Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 191, 80, 239),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      ),
    );
  }

  String getStatusColor(String? status) {
    switch (status!.toLowerCase()) {
      case 'Paid':
        return "";
      case 'Rejected':
        return "";
      case 'Accepted':
        return "";
      case 'requested':
        return "";
      default:
        return "Request";
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
              const Text('Income Certificate'),
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
