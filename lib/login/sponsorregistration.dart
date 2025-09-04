import 'dart:convert';
import 'dart:io';

import 'package:edusponsor/Common/inputdecoration.dart';
import 'package:edusponsor/Common/loading_indicator%20copy.dart';
import 'package:edusponsor/login/registercubit/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class SponsorRegistration extends StatefulWidget {
  const SponsorRegistration({super.key});

  @override
  State<SponsorRegistration> createState() => _SponsorRegistrationState();
}

class _SponsorRegistrationState extends State<SponsorRegistration> {
  final _formKey = GlobalKey<FormBuilderState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _selectedLocation;
  String? _base64IncomeProof;
  String? _pickedFileName;

  // State variables for password visibility
  bool _isPasswordVisible = false;
  bool _isRePasswordVisible = false;

  final List<String> _locations = [
    "Chennai",
    "Mumbai",
    "Delhi",
    "Bangalore",
    "Kolkata",
    "Hyderabad",
    "Pune",
    "Ahmedabad",
    "Kochi",
    "Jaipur",
    "Bhopal",
    "Patna",
    "Lucknow",
    "Coimbatore",
  ];

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter an email";
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return "Enter a valid email";
    }
    return null;
  }

  void _submitForm() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      Map body = {
        "username": _usernameController.text,
        "password": _passwordController.text,
        "fullname": _fullNameController.text,
        "email": _emailController.text,
        "incomeProofBaseSF": _base64IncomeProof,
        "location": _selectedLocation,
      };
      context.read<RegisterCubit>().registerSponsor(body);
    }
  }

  Future<void> _pickPDF() async {
    print("PDF picker tapped");
    try {
      final path = await FlutterDocumentPicker.openDocument(
        params: FlutterDocumentPickerParams(
          allowedFileExtensions: ['pdf'],
          allowedUtiTypes: ['com.adobe.pdf'],
          allowedMimeTypes: ['application/pdf'],
        ),
      );

      if (path != null) {
        final file = File(path);
        final bytes = await file.readAsBytes();
        setState(() {
          _base64IncomeProof = base64Encode(bytes);
          _pickedFileName = file.uri.pathSegments.last;
        });
      }
    } catch (e) {
      print("File picking error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSponsSuccess || state is RegisterSponsFailed) {
            Navigator.pop(context);
          }
        },
        child: Stack(
          children: [
            SizedBox.expand(
              child: Image.asset(
                'assets/images/loginbackground.png',
                fit: BoxFit.cover,
              ),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.7,
                    child: Image.asset('assets/images/edusponsorlogo.png'),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.9,
                    child: registerSponsorForm(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget registerSponsorForm() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              spreadRadius: 5,
              blurRadius: 15,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(32.0),
        child: BlocBuilder<RegisterCubit, RegisterState>(
          builder: (context, state) {
            if (state is RegisterSponsLoading) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [LoadingIndicator()],
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Register',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Sponsor',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 48),
                    FormBuilder(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: TextFormField(
                              controller: _usernameController,
                              decoration: getInputDecoration("Username"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter a username";
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: TextFormField(
                              controller: _passwordController,
                              decoration: getInputDecoration("Password").copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                              obscureText: !_isPasswordVisible,
                              validator: (value) {
                                if (value == null || value.length < 6) {
                                  return "Password must be at least 6 characters";
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: TextFormField(
                              controller: _rePasswordController,
                              decoration: getInputDecoration("Re-enter Password")
                                  .copyWith(
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isRePasswordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isRePasswordVisible =
                                              !_isRePasswordVisible;
                                        });
                                      },
                                    ),
                                  ),
                              obscureText: !_isRePasswordVisible,
                              validator: (value) {
                                if (value != _passwordController.text) {
                                  return "Passwords do not match";
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: TextFormField(
                              controller: _fullNameController,
                              decoration: getInputDecoration("Full Name"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your name";
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: TextFormField(
                              controller: _emailController,
                              decoration: getInputDecoration("Email"),
                              validator: _validateEmail,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: TextFormField(
                              decoration: getInputDecoration("Income proof")
                                  .copyWith(
                                    suffixIcon: const Icon(
                                      Icons.attach_file,
                                      color: Colors.white,
                                    ),
                                  ),
                              controller: TextEditingController(
                                text: _pickedFileName ?? '',
                              ),
                              validator: (value) {
                                if (_base64IncomeProof == null) {
                                  return "Please upload income proof";
                                }
                                return null;
                              },
                              readOnly: true,
                              onTap: _pickPDF,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: DropdownButtonFormField<String>(
                              value: _selectedLocation,
                              decoration: getInputDecoration("Location"),
                              items: _locations.map((location) {
                                return DropdownMenuItem(
                                  value: location,
                                  child: Text(location),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedLocation = value;
                                });
                              },
                              validator: (value) => value == null
                                  ? "Please select a location"
                                  : null,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0D6EFD),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                elevation: 5,
                              ),
                              onPressed: _submitForm,
                              child: const Text(
                                "Register",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 5,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Back",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
