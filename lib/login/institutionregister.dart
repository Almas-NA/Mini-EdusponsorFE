import 'package:edusponsor/Common/inputdecoration.dart';
import 'package:edusponsor/Common/loading_indicator%20copy.dart';
import 'package:edusponsor/login/registercubit/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class InstitutionRegistration extends StatefulWidget {
  const InstitutionRegistration({super.key});

  @override
  State<InstitutionRegistration> createState() =>
      _InstitutionRegistrationState();
}

class _InstitutionRegistrationState extends State<InstitutionRegistration> {
  final _formKey = GlobalKey<FormBuilderState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _institutionNameController =
      TextEditingController();
  final TextEditingController _institutionIdController =
      TextEditingController();

  String? _selectedLocation;

  bool _isPasswordVisible = false;
  bool _isRePasswordVisible = false;

  final List<String> _locations = [
    "Kasar",
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

  void _submitForm() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      Map body = {
        "username": _usernameController.text,
        "password": _passwordController.text,
        "email": _emailController.text,
        "instituteName": _institutionNameController.text,
        "instituteId": _institutionIdController.text,
        "location": _selectedLocation,
      };
      context.read<RegisterCubit>().registerInstitution(body);
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterInstSuccess || state is RegisterInstFailed) {
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
                    height: MediaQuery.of(context).size.height*0.9,
                    child: registerInstitutionForm(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget registerInstitutionForm() {
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
            if (state is RegisterInstLoading) {
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
                      'Institution',
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
                              controller: _emailController,
                              decoration: getInputDecoration("Email"),
                              validator: _validateEmail,
                            ),
                          ),
                
                          // Institution Name
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: TextFormField(
                              controller: _institutionNameController,
                              decoration: getInputDecoration("Institution Name"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter institution name";
                                }
                                return null;
                              },
                            ),
                          ),
                
                          // Institution ID
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: TextFormField(
                              controller: _institutionIdController,
                              decoration: getInputDecoration("Institution ID"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter institution ID";
                                }
                                return null;
                              },
                            ),
                          ),
                
                          // Location Dropdown
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
