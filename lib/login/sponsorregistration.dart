import 'dart:convert';
import 'dart:io';
import 'package:edusponsor/Common/inputdecoration.dart';
import 'package:edusponsor/Common/loading_indicator%20copy.dart';
import 'package:edusponsor/login/registercubit/register_cubit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final TextEditingController _contactNumber= TextEditingController();
  String? _selectedLocation;
  String? _base64IncomeProof;

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

  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      List<int> fileBytes = await file.readAsBytes();
      setState(() {
        _base64IncomeProof = base64Encode(fileBytes);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      if (_base64IncomeProof == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please upload income proof")),
        );
        return;
      }

      Map body = {
        "username": _usernameController.text,
        "password": _passwordController.text,
        "fullName": _fullNameController.text,
        "email": _emailController.text,
        "contactNumber": _contactNumber.text,
        "incomeProofBaseSF": _base64IncomeProof,
        "location": _selectedLocation,
      };
      context.read<RegisterCubit>().registerSponsor(body);
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
            // Background
            SizedBox.expand(
              child: Image.asset(
                'assets/images/loginbackground.png',
                fit: BoxFit.cover,
              ),
            ),
            // Scrollable content
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 30),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.5,
                      child: Image.asset('assets/images/edusponsorlogo.png'),
                    ),
                    registerSponsorForm(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget registerSponsorForm() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
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
      padding: const EdgeInsets.all(24.0),
      child: BlocBuilder<RegisterCubit, RegisterState>(
        builder: (context, state) {
          return FormBuilder(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                const SizedBox(height: 8),
                const Text(
                  'Sponsor',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 32),

                // Username
                TextFormField(
                  controller: _usernameController,
                  decoration: getInputDecoration("Username"),
                  validator: (value) => value == null || value.isEmpty
                      ? "Please enter a username"
                      : null,
                ),
                const SizedBox(height: 12),

                // Password
                TextFormField(
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
                  validator: (value) => value == null || value.length < 6
                      ? "Password must be at least 6 characters"
                      : null,
                ),
                const SizedBox(height: 12),

                // Re-enter Password
                TextFormField(
                  controller: _rePasswordController,
                  decoration: getInputDecoration("Re-enter Password").copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isRePasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _isRePasswordVisible = !_isRePasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isRePasswordVisible,
                  validator: (value) => value != _passwordController.text
                      ? "Passwords do not match"
                      : null,
                ),
                const SizedBox(height: 12),

                // Full Name
                TextFormField(
                  controller: _fullNameController,
                  decoration: getInputDecoration("Full Name"),
                  validator: (value) => value == null || value.isEmpty
                      ? "Please enter your name"
                      : null,
                ),
                const SizedBox(height: 12),

                // Email
                TextFormField(
                  controller: _emailController,
                  decoration: getInputDecoration("Email"),
                  validator: _validateEmail,
                ),
                const SizedBox(height: 12),

                // Email
                TextFormField(
                  controller: _emailController,
                  decoration: getInputDecoration("contactNumber"),
                  validator: _validateEmail,
                ),
                const SizedBox(height: 12),

                // File picker
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickDocument,
                      label: const Text(
                        "Upload Income Proof",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      icon: const Icon(Icons.upload_file, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D6EFD),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 20,
                        ),
                        elevation: 5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_base64IncomeProof != null)
                      const Text(
                        "Document uploaded successfully ✔",
                        style: TextStyle(color: Colors.green, fontSize: 14),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // Location
                DropdownButtonFormField<String>(
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
                  validator: (value) =>
                      value == null ? "Please select a location" : null,
                ),
                const SizedBox(height: 24),
                (state is RegisterSponsLoading)
                    ? LoadingIndicator()
                    : ElevatedButton(
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
                const SizedBox(height: 12),

                // Back button
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
          );
        },
      ),
    );
  }
}
