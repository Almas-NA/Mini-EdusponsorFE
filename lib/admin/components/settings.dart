import 'package:edusponsor/Common/inputdecoration.dart';
import 'package:edusponsor/Common/loading_indicator.dart';
import 'package:edusponsor/admin/cubits/settings/profile/profile_cubit.dart';
import 'package:edusponsor/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hive/hive.dart';

class AdminSettings extends StatefulWidget {
  const AdminSettings({super.key});

  @override
  State<AdminSettings> createState() => _AdminSettingsState();
}

class _AdminSettingsState extends State<AdminSettings> {
  Box box = Hive.box('eduSponsor');
  final _formKey = GlobalKey<FormBuilderState>();
  bool isEditMode = false;

  void _updateProfile() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formValues = _formKey.currentState!.value;

      Map body = {
        "id": box.get('userId'),
        "firstName": formValues['firstname'],
        "secondName": formValues['secondname'],
      };

      context.read<ProfileCubit>().updateAdminInfo(body);
    }
  }

  void _getProfile() {
    Map body = {"id": box.get('userId')};
    context.read<ProfileCubit>().getAdminInfo(body);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdateSuccess) {
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
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileInfoLoading) {
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
                                      name: 'firstname',
                                      initialValue:
                                          (state is ProfileInfoSuccess)
                                          ? state.adminDetails['firstName'] ??
                                                ""
                                          : "",
                                      decoration: getInputDecoration(
                                        "First Name",
                                      ),
                                      validator: FormBuilderValidators.compose([
                                        FormBuilderValidators.required(),
                                        FormBuilderValidators.minLength(2),
                                      ]),
                                    ),
                                    const SizedBox(height: 16),
                                    FormBuilderTextField(
                                      name: 'secondname',
                                      initialValue:
                                          (state is ProfileInfoSuccess)
                                          ? state.adminDetails['secondName'] ??
                                                ""
                                          : "",
                                      decoration: getInputDecoration(
                                        "Second Name",
                                      ),
                                      validator: FormBuilderValidators.compose([
                                        FormBuilderValidators.required(),
                                        FormBuilderValidators.minLength(2),
                                      ]),
                                    ),
                                    const SizedBox(height: 20),
                                    BlocBuilder<ProfileCubit, ProfileState>(
                                      builder: (context, state) {
                                        if (state is ProfileUpdateLoading) {
                                          return LoadingIndicator();
                                        }
                                        return SizedBox(
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.2,
                                          child: ElevatedButton.icon(
                                            onPressed: _updateProfile,
                                            icon: const Icon(Icons.save),
                                            label: const Text(
                                              "Update",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
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
