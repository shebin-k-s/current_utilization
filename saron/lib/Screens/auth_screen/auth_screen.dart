import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:saron/Screens/auth_screen/forgetpassword_screen.dart';
import 'package:saron/Screens/main_sceen/main_screen.dart';
import 'package:saron/api/data/auth.dart';
import 'package:saron/api/data/device.dart';
import 'package:saron/widgets/snackbar_message/snackbar_message.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();

  final _emailController = TextEditingController(text: "sshebi71@gmail.com");
  final _passwordController = TextEditingController(text: "shebin");
  final ValueNotifier<bool> signUp = ValueNotifier(false);
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text('Tap back again to leave'),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(179, 43, 42, 42),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircleAvatar(
                          backgroundColor: Color.fromARGB(179, 82, 82, 82),
                          radius: 48,
                          child: Icon(
                            Icons.person,
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                        ValueListenableBuilder(
                            valueListenable: signUp,
                            builder: (context, value, child) {
                              return value
                                  ? Column(
                                      children: [
                                        SizedBox(height: 30),
                                        TextFormField(
                                          controller: _usernameController,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor:
                                                Color.fromARGB(179, 82, 82, 82),
                                            label: const Text(
                                              'Username',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            hintStyle:
                                                TextStyle(color: Colors.white),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                            prefixIcon: const Icon(
                                              Icons.person,
                                              color: Colors.white,
                                            ),
                                            errorStyle: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your name';
                                            }

                                            return null;
                                          },
                                        ),
                                      ],
                                    )
                                  : SizedBox.shrink();
                            }),
                        SizedBox(height: 30),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromARGB(179, 82, 82, 82),
                            label: const Text(
                              'Email ID',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            prefixIcon: const Icon(
                              Icons.email,
                              color: Colors.white,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 30),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromARGB(179, 82, 82, 82),
                            label: const Text(
                              'Password',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.white,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }

                            return null;
                          },
                        ),
                        ValueListenableBuilder(
                            valueListenable: signUp,
                            builder: (context, value, child) {
                              return Column(
                                children: [
                                  if (value) ...[
                                    SizedBox(height: 30),
                                    TextFormField(
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor:
                                            Color.fromARGB(179, 82, 82, 82),
                                        label: const Text(
                                          'Confirm Password',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.lock,
                                          color: Colors.white,
                                        ),
                                        errorStyle: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your password';
                                        }
                                        if (value != _passwordController.text) {
                                          return 'Passwords do not match';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                  SizedBox(height: 20),
                                  Container(
                                    width: double.infinity,
                                    child: GestureDetector(
                                      onTap: () => Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (ctx) =>
                                            ForgetPasswordScreen(),
                                      )),
                                      child: const Text(
                                        'Forget Password?',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  ValueListenableBuilder(
                                    valueListenable: _isLoading,
                                    builder: (context, value, child) {
                                      if (value) {
                                        return const Column(
                                          children: [
                                            CircularProgressIndicator(),
                                            SizedBox(height: 16),
                                          ],
                                        );
                                      } else {
                                        return const SizedBox.shrink();
                                      }
                                    },
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      login(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      backgroundColor:
                                          Color.fromARGB(179, 82, 82, 82),
                                    ),
                                    child: Text(
                                      value ? "SIGNUP" : "LOGIN",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        value
                                            ? "Already have an account? "
                                            : "Don't have an account? ",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => signUp.value = !value,
                                        child: Text(
                                          value ? "Log In" : "Sign Up",
                                          style: const TextStyle(
                                            color: Colors.blue,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              );
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void login(BuildContext ctx) async {
    if (_formKey.currentState!.validate()) {
      _isLoading.value = true;

      final _email = _emailController.text;
      final _password = _passwordController.text;
      final _username = _usernameController.text;
      var _errorMessage;

      if (signUp.value) {
        final _statusCode =
            await AuthDB().userSignup(_username, _email, _password);
        if (_statusCode == 201) {
          _errorMessage = "Account created successfully";
          signUp.value = false;
        } else if (_statusCode == 400) {
          _errorMessage = "Email already exist";
        } else {
          _errorMessage = "Internal server error";
        }
      } else {
        final _statusCode = await AuthDB().userLogin(_email, _password);
        if (_statusCode == 200) {
          await DeviceDB().getDevices();
          Navigator.of(ctx).pushReplacement(
            MaterialPageRoute(
              builder: (context) => MainScreen(),
            ),
          );
        } else if (_statusCode == 404) {
          _errorMessage = "Email doesn't exist";
        } else if (_statusCode == 401) {
          _errorMessage = "Incorrect Password";
        } else {
          _errorMessage = "Internal server error";
        }
      }

      snackbarMessage(ctx, _errorMessage);
      _isLoading.value = false;
    }
  }
}
