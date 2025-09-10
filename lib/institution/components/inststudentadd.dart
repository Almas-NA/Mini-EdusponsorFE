import 'dart:convert';
import 'package:edusponsor/Common/inputdecoration.dart';
import 'package:edusponsor/Common/loading_indicator%20copy.dart';
import 'package:edusponsor/config.dart';
import 'package:edusponsor/institution/cubit/studentcubit/student_cubit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class InstitutionStudentAdd extends StatefulWidget {
  const InstitutionStudentAdd({super.key});

  @override
  State<InstitutionStudentAdd> createState() => _InstitutionStudentAddState();
}

class _InstitutionStudentAddState extends State<InstitutionStudentAdd> {
  var _formKey = GlobalKey<FormState>();
  Box box = Hive.box('eduSponsor');

  // Controllers
  final _firstNameController = TextEditingController();
  final _secondNameController = TextEditingController();
  final _departmentController = TextEditingController();
  final _studentEmailController = TextEditingController();
  final _studentContactController = TextEditingController();
  final _parentNameController = TextEditingController();
  final _parentEmailController = TextEditingController();
  final _parentContactController = TextEditingController();
  final _incomeController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _selectedYear;
  String? _selectedRelation;

  final List<String> _years = ['1st Year', '2nd Year', '3rd Year', '4th Year'];
  final List<String> _relations = ['Father', 'Mother', 'Guardian', 'Other'];

  // For PDF Upload
  String? _incomeProofBase64;
  String? _selectedFileName;

  Future<void> _pickPdf() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
    withData: true, // Important for Flutter Web
  );

  if (result != null) {
    setState(() {
      _incomeProofBase64 = base64Encode(result.files.single.bytes!); // ✅ works on web
      _selectedFileName = result.files.single.name;
    });
  }
}

  @override
  void dispose() {
    _firstNameController.dispose();
    _secondNameController.dispose();
    _departmentController.dispose();
    _studentEmailController.dispose();
    _studentContactController.dispose();
    _parentNameController.dispose();
    _parentEmailController.dispose();
    _parentContactController.dispose();
    _incomeController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_incomeProofBase64 == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please upload Income Proof PDF"),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      final studentData = {
        "instituteId": box.get('userId'),
        "firstName": _firstNameController.text,
        "secondName": _secondNameController.text,
        "department": _departmentController.text,
        "year": _selectedYear,
        "username": _usernameController.text,
        "password": _passwordController.text,
        "studentEmail": _studentEmailController.text,
        "studentContact": _studentContactController.text,
        "parentName": _parentNameController.text,
        "parentEmail": _parentEmailController.text,
        "parentContact": _parentContactController.text,
        "relation": _selectedRelation,
        "annualIncome": _incomeController.text,
        "incomeProof": _incomeProofBase64, // ✅ attach pdf
      };
      context.read<StudentCubit>().addStudent(studentData);
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: primaryShadeLight,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f9fa),
      body: BlocListener<StudentCubit, StudentState>(
        listener: (context, state) {
          if (state is StudentAddSuccess) {
            setState(() {
              _selectedYear = null;
              _selectedRelation = null;
              _firstNameController.clear();
              _secondNameController.clear();
              _departmentController.clear();
              _studentEmailController.clear();
              _studentContactController.clear();
              _parentNameController.clear();
              _parentEmailController.clear();
              _parentContactController.clear();
              _incomeController.clear();
              _usernameController.clear();
              _passwordController.clear();
              _incomeProofBase64 = null;
              _selectedFileName = null;
              _formKey = GlobalKey<FormState>();

              context.read<StudentCubit>().reset();
            });
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
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
                      _buildSectionTitle("Student Information"),
                      TextFormField(
                        controller: _firstNameController,
                        decoration: getInputDecoration(
                          "First Name",
                        ).copyWith(prefixIcon: const Icon(Icons.person)),
                        validator: (value) =>
                            value!.isEmpty ? "Enter first name" : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _secondNameController,
                        decoration: getInputDecoration("Second Name").copyWith(
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "Enter second name" : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _departmentController,
                        decoration: getInputDecoration(
                          "Department",
                        ).copyWith(prefixIcon: const Icon(Icons.school)),
                        validator: (value) =>
                            value!.isEmpty ? "Enter department" : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        decoration: getInputDecoration("Year").copyWith(
                          prefixIcon: const Icon(Icons.calendar_month),
                        ),
                        value: _selectedYear,
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

                      _buildSectionTitle("Login Credentials"),
                      TextFormField(
                        controller: _usernameController,
                        decoration: getInputDecoration("Username").copyWith(
                          prefixIcon: const Icon(Icons.account_circle),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "Enter username" : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: getInputDecoration(
                          "Password",
                        ).copyWith(prefixIcon: const Icon(Icons.lock)),
                        validator: (value) =>
                            value!.isEmpty ? "Enter password" : null,
                      ),
                      const SizedBox(height: 25),

                      _buildSectionTitle("Parent/Guardian Details"),
                      TextFormField(
                        controller: _parentNameController,
                        decoration: getInputDecoration("Parent/Guardian Name")
                            .copyWith(
                              prefixIcon: const Icon(Icons.family_restroom),
                            ),
                        validator: (value) =>
                            value!.isEmpty ? "Enter parent name" : null,
                      ),
                      const SizedBox(height: 12),
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
                      DropdownButtonFormField<String>(
                        decoration: getInputDecoration(
                          "Relation",
                        ).copyWith(prefixIcon: const Icon(Icons.people)),
                        value: _selectedRelation,
                        items: _relations
                            .map(
                              (rel) => DropdownMenuItem(
                                value: rel,
                                child: Text(rel),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _selectedRelation = value),
                        validator: (value) =>
                            value == null ? "Select relation" : null,
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

                      const SizedBox(height: 12),
                      Text(
                        "Upload Income Proof (PDF)",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: primaryShadeLight,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedFileName ?? "No file selected",
                              style: TextStyle(
                                fontSize: 14,
                                color: _selectedFileName == null
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: _pickPdf,
                            icon: const Icon(Icons.upload_file),
                            label: const Text("Choose File"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryShadeLight,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: 50,
                          child: BlocBuilder<StudentCubit, StudentState>(
                            builder: (context, state) {
                              if (state is StudentAddLoading) {
                                return const LoadingIndicator();
                              }
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryShadeLight,
                                  foregroundColor: primaryShadeLight,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  elevation: 3,
                                ),
                                onPressed: _submitForm,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "Submit",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            },
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
      ),
    );
  }
}
