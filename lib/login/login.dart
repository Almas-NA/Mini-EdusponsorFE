import 'package:edusponsor/Common/enums/response_type_enum.dart';
import 'package:edusponsor/Common/enums/user_role_enum.dart';
import 'package:edusponsor/Common/inputdecoration.dart';
import 'package:edusponsor/Common/loading_indicator%20copy.dart';
import 'package:edusponsor/Common/snack_bar.dart';
import 'package:edusponsor/admin/admin.dart';
import 'package:edusponsor/institution/institution.dart';
import 'package:edusponsor/login/authcubit/user_cubit.dart';
import 'package:edusponsor/sponsor/sponsor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hive/hive.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isPasswordVisible = false;
  Box box = Hive.box('eduSponsor');

  Future<void> submitForm() async {
    if (_formKey.currentState!.validate()) {
      context.read<UserCubit>().userLogin(
        _userNameController.text,
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<UserCubit, UserState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            box.put('userId', state.userDetails['id'] ?? "");
            if (state.userDetails['role'] == UserRoleEnum.ADMIN.name) {
              if (!kIsWeb) {
                displaySnackBar(
                  message: "Admin have no access through mobile, Try on web!",
                  type: ServerResponseType.WARNING.name,
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Admin()),
                );
              }
            } else {
              if (!kIsWeb) {
                if (state.userDetails['role'] ==
                    UserRoleEnum.INSTITUTION.name) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const Institution()),
                  );
                } else if (state.userDetails['role'] ==
                    UserRoleEnum.SPONSOR.name) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const Sponsor()),
                  );
                } else {
                  displaySnackBar(
                    message: "No user detected!",
                    type: ServerResponseType.WARNING.name,
                  );
                }
              } else {
                displaySnackBar(
                  message: "Only admin have access through web, Try on mobile!",
                  type: ServerResponseType.WARNING.name,
                );
              }
            }
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            // breakpoint - adjust if needed
            bool isWide = constraints.maxWidth > 800;

            if (isWide) {
              // Web layout (Row)
              return Stack(
                children: [
                  SizedBox.expand(
                    child: Image.asset(
                      'assets/images/loginbackground.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: constraints.maxWidth * 0.5,
                        height: constraints.maxWidth * 0.7,
                        child: Image.asset('assets/images/edusponsorlogo.png'),
                      ),
                      SizedBox(
                        width: constraints.maxWidth * 0.3,
                        height: constraints.maxWidth * 0.3,
                        child: loginForm(),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              // Mobile layout (Column)
              return Stack(
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
                          height: constraints.maxWidth * 0.7,
                          child: Image.asset(
                            'assets/images/edusponsorlogo.png',
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: loginForm(),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget loginForm() {
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
        child: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state is LoginLoading) {
              return const Center(child: LoadingIndicator());
            } else {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Welcome',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    if (kIsWeb)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          '"Only admin can access the web page"',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    FormBuilder(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FormBuilderTextField(
                              name: "username",
                              controller: _userNameController,
                              decoration: getInputDecoration("User Name"),
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Username cannot be empty!';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FormBuilderTextField(
                              name: "password",
                              controller: _passwordController,
                              obscureText: !isPasswordVisible,
                              decoration: getInputDecoration("Password")
                                  .copyWith(
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        isPasswordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          isPasswordVisible =
                                              !isPasswordVisible;
                                        });
                                      },
                                    ),
                                  ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Password cannot be empty!';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0D6EFD),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                elevation: 5,
                              ),
                              onPressed: submitForm,
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          if (!kIsWeb)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  elevation: 5,
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    "/register/institution",
                                  );
                                },
                                child: const Text(
                                  "Institution Registration",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ),
                          if (!kIsWeb)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  elevation: 5,
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    "/register/sponsor",
                                  );
                                },
                                child: const Text(
                                  "Sponsor Registration",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                  ),
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
