import 'package:edusponsor/Common/inputdecoration.dart';
import 'package:edusponsor/Common/loading_indicator%20copy.dart';
import 'package:edusponsor/Common/widgets.dart';
import 'package:edusponsor/config.dart';
import 'package:edusponsor/institution/cubit/instituteprofilecubit/institutionprofile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hive/hive.dart';

class InstitutionSettings extends StatefulWidget {
  const InstitutionSettings({super.key});

  @override
  State<InstitutionSettings> createState() => _InstitutionSettingsState();
}

class _InstitutionSettingsState extends State<InstitutionSettings> {
  Box box = Hive.box('eduSponsor');
  final _formKey = GlobalKey<FormBuilderState>();
  bool isEditMode = false;

  void _updateProfile() {
    alertD(
      context: context,
      title: "Warning",
      content: "Confirm to Update information?",
      buttonText1: "No",
      buttonText2: "Yes",
      fn1: () {
        Navigator.of(context).pop();
      },
      fn2: () {
        if (_formKey.currentState?.saveAndValidate() ?? false) {
          final formValues = _formKey.currentState!.value;

          Map body = {
            "id": box.get('userId'),
            "instituteName": formValues['instituteName'],
            "email": formValues['email'],
            "instituteId": formValues['instituteId'],
          };

          context.read<InstitutionprofileCubit>().updateInstitutionInfo(body);
        }
      },
    );
  }

  void _getProfile() {
    Map body = {"id": box.get('userId')};
    context.read<InstitutionprofileCubit>().getInstitutionInfo(body);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InstitutionprofileCubit, InstitutionprofileState>(
      listener: (context, state) {
        if (state is InstitutionprofileUpdateSuccess) {
          _getProfile();
          setState(() {
            isEditMode = !isEditMode;
          });
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              BlocBuilder<InstitutionprofileCubit, InstitutionprofileState>(
                builder: (context, state) {
                  if (state is InstitutionprofileInfoLoading) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.05,
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.1,
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: secondaryColor!,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueAccent.withOpacity(0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: LoadingIndicator(),
                      ),
                    );
                  }
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.05,
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: secondaryColor!, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ExpansionTile(
                        initiallyExpanded: true,
                        backgroundColor:
                            Colors.transparent, // So it blends with container
                        collapsedBackgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        collapsedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        tilePadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              isEditMode = !isEditMode;
                            });
                          },
                          icon: Icon((isEditMode) ? Icons.close : Icons.edit),
                        ),
                        title: Row(
                          children: [
                            const Icon(Icons.person, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(
                              "Profile",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        children: [
                          AbsorbPointer(
                            absorbing: !isEditMode,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: FormBuilder(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    FormBuilderTextField(
                                      name: 'instituteName',
                                      initialValue:
                                          (state
                                              is InstitutionprofileInfoSuccess)
                                          ? state.institutionDetails['instituteName'] ??
                                                ""
                                          : "",
                                      decoration: getInputDecoration(
                                        "Institute Name",
                                      ),
                                      validator: FormBuilderValidators.compose([
                                        FormBuilderValidators.required(),
                                        FormBuilderValidators.minLength(2),
                                      ]),
                                    ),
                                    const SizedBox(height: 16),
                                    FormBuilderTextField(
                                      name: 'email',
                                      initialValue:
                                          (state
                                              is InstitutionprofileInfoSuccess)
                                          ? state.institutionDetails['email'] ??
                                                ""
                                          : "",
                                      decoration: getInputDecoration("Email"),
                                      validator: FormBuilderValidators.compose([
                                        FormBuilderValidators.required(),
                                        FormBuilderValidators.minLength(2),
                                      ]),
                                    ),
                                    const SizedBox(height: 16),
                                    FormBuilderTextField(
                                      name: 'instituteId',
                                      initialValue:
                                          (state
                                              is InstitutionprofileInfoSuccess)
                                          ? state.institutionDetails['instituteId'] ??
                                                ""
                                          : "",
                                      decoration: getInputDecoration(
                                        "Institution ID",
                                      ),
                                      validator: FormBuilderValidators.compose([
                                        FormBuilderValidators.required(),
                                        FormBuilderValidators.minLength(2),
                                      ]),
                                    ),
                                    const SizedBox(height: 20),
                                    BlocBuilder<
                                      InstitutionprofileCubit,
                                      InstitutionprofileState
                                    >(
                                      builder: (context, state) {
                                        if (state
                                            is InstitutionprofileUpdateLoading) {
                                          return LoadingIndicator();
                                        }
                                        return Center(
                                          child: SizedBox(
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.3,
                                            height: 50,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    primaryShadeLight,
                                                foregroundColor:
                                                    primaryShadeLight,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 14,
                                                    ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                textStyle: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                elevation: 3,
                                              ),
                                              onPressed: _updateProfile,
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
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
