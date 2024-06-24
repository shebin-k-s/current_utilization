import 'package:flutter/material.dart';
import 'package:saron/api/data/auth.dart';
import 'package:saron/widgets/snackbar_message/snackbar_message.dart';

class ForgetPasswordScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final String? email;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();

  final ValueNotifier<bool> _emailValidated = ValueNotifier(false);
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  ForgetPasswordScreen({Key? key, this.email}) : super(key: key) {
    _emailController.text = email ?? "";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: const BottomAppBar(
        color: Colors.black,
      ),
      body: Padding(
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
                    const Center(
                      child: Text(
                        "Reset Password",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ValueListenableBuilder(
                      valueListenable: _emailValidated,
                      builder: (context, value, child) {
                        return Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              readOnly: value,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color.fromARGB(179, 82, 82, 82),
                                label: const Text(
                                  'Email ID',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                            if (value) ...[
                              SizedBox(
                                height: 30,
                              ),
                              TextFormField(
                                controller: _tokenController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color.fromARGB(179, 82, 82, 82),
                                  label: const Text(
                                    'Token',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.security,
                                    color: Colors.white,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'paste the token sent to your Email';
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
                                    'New Password',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                                    return 'Please enter New Password';
                                  }

                                  return null;
                                },
                              ),
                              SizedBox(height: 30),
                              TextFormField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color.fromARGB(179, 82, 82, 82),
                                  label: const Text(
                                    'Confirm Password',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
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
                                    return 'Please enter password';
                                  }
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              ),
                            ],
                            SizedBox(
                              height: 30,
                            ),
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
                                resetPassword(context);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                backgroundColor:
                                    Color.fromARGB(179, 82, 82, 82),
                              ),
                              child: Text(
                                "SUBMIT",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void resetPassword(BuildContext ctx) async {
    if (_formKey.currentState!.validate()) {
      _isLoading.value = true;

      final _email = _emailController.text;
      final _password = _passwordController.text;
      final _token = _tokenController.text;
      var _errorMessage;

      if (_emailValidated.value) {
        final _statusCode =
            await AuthDB().resetPassword(_email, _token, _password);
        if (_statusCode == 200) {
          _errorMessage = "Password Changed successfully";
          Navigator.of(ctx).pop();
        } else if (_statusCode == 404) {
          _errorMessage = "User doesn't exist";
        } else if (_statusCode == 401) {
          _errorMessage = "Invalid or Expired Token";
        } else {
          _errorMessage = "Internal server error";
        }
      } else {
        final _statusCode = await AuthDB().forgetPassword(_email);
        if (_statusCode == 200) {
          _errorMessage = "Reset token sent to your Email";
          _emailValidated.value = true;
        } else if (_statusCode == 500) {
          _errorMessage = "Failed to send reset password email";
        } else if (_statusCode == 404) {
          _errorMessage = "Email doesn't belongs to any user";
        } else {
          _errorMessage = "Internal server error";
        }
      }

      snackbarMessage(ctx, _errorMessage);
      _isLoading.value = false;
    }
  }
}
