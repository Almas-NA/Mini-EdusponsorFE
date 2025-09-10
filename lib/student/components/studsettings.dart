import 'package:edusponsor/Common/inputdecoration.dart';
import 'package:edusponsor/config.dart';
import 'package:edusponsor/student/cubit/studentinfocubit/studinfo_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hive/hive.dart';

class StudentSettings extends StatefulWidget {
  const StudentSettings({super.key});

  @override
  State<StudentSettings> createState() => _StudentSettingsState();
}

class _StudentSettingsState extends State<StudentSettings> {
  Box box = Hive.box('eduSponsor');
  final _formKey = GlobalKey<FormBuilderState>();
  bool isEditMode = false;

  final List<String> _years = ['1st Year', '2nd Year', '3rd Year', '4th Year'];
  void _getProfile() {
    final body = {"id": box.get('refId')};
    context.read<StudinfoCubit>().getStudentInfo(body);
  }

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  void _updateProfile() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formValues = _formKey.currentState!.value;

      Map body = {
        "id": box.get('refId'),
        "firstName": formValues['firstName'],
        "secondName": formValues['secondName'],
        "year": formValues['year'],
        "studentEmail": formValues['studentEmail'],
        "studentContact": formValues['studentContact'],
      };

      context.read<StudinfoCubit>().updateStudentInfo(body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<StudinfoCubit, StudinfoState>(
        listener: (context, state) {
          if (state is StudinfoUpdateloaded) {
            _getProfile();
            setState(() {
              isEditMode = !isEditMode;
            });
          }
        },
        builder: (context, state) {
          if (state is StudinfoLoading || state is StudinfoUpdateLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is StudinfoError) {
            return const Center(child: Text("Failed to load profile"));
          } else if (state is StudinfoLoaded) {
            final student = state.studentDetails;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: MediaQuery.of(context).size.width * 0.85,
                  constraints: const BoxConstraints(maxWidth: 500),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryShadeLight, secondaryColor!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.school, color: Colors.white, size: 26),
                              SizedBox(width: 8),
                              Text(
                                "Student Profile",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() => isEditMode = !isEditMode);
                            },
                            icon: Icon(
                              isEditMode ? Icons.close : Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Form
                      AbsorbPointer(
                        absorbing: !isEditMode,
                        child: FormBuilder(
                          key: _formKey,
                          initialValue: {
                            "firstName": student["firstName"] ?? "",
                            "secondName": student["secondName"] ?? "",
                            "year": student["year"] ?? _years.first,
                            "studentEmail": student["studentEmail"] ?? "",
                            "studentContact": student["studentContact"] ?? "",
                          },
                          child: Column(
                            children: [
                              FormBuilderTextField(
                                name: 'firstName',
                                decoration: getInputDecoration("First Name"),
                                validator: FormBuilderValidators.required(),
                              ),
                              const SizedBox(height: 16),

                              FormBuilderTextField(
                                name: 'secondName',
                                decoration: getInputDecoration("Second Name"),
                                validator: FormBuilderValidators.required(),
                              ),
                              const SizedBox(height: 16),

                              FormBuilderDropdown<String>(
                                name: 'year',
                                items: _years
                                    .map(
                                      (year) => DropdownMenuItem(
                                        value: year,
                                        child: Text(year),
                                      ),
                                    )
                                    .toList(),
                                decoration: getInputDecoration("Year"),
                                validator: FormBuilderValidators.required(),
                              ),
                              const SizedBox(height: 16),

                              FormBuilderTextField(
                                name: 'studentEmail',
                                decoration: getInputDecoration("Email"),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.email(),
                                ]),
                              ),
                              const SizedBox(height: 16),

                              FormBuilderTextField(
                                name: 'studentContact',
                                decoration: getInputDecoration(
                                  "Contact Number",
                                ),
                                keyboardType: TextInputType.phone,
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.numeric(),
                                  FormBuilderValidators.minLength(10),
                                  FormBuilderValidators.maxLength(10),
                                ]),
                              ),
                              const SizedBox(height: 24),

                              if (isEditMode)
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: primaryShadeLight,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      elevation: 4,
                                    ),
                                    onPressed: _updateProfile,
                                    child: const Text(
                                      "Save Changes",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
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
          return const SizedBox.shrink(); // default
        },
      ),
    );
  }
}
