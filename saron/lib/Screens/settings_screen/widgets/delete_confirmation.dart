import 'package:flutter/material.dart';
import 'package:saron/Screens/auth_screen/auth_screen.dart';
import 'package:saron/api/data/auth.dart';
import 'package:saron/widgets/snackbar_message/snackbar_message.dart';
import 'package:saron/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeleteConfirmation extends StatelessWidget {
  DeleteConfirmation({super.key});
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<String> _errorMessage = ValueNotifier("");

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Deletion'),
      content: const Text(
        'Are you sure you want to delete your account?',
        style: TextStyle(color: Colors.black),
      ),
      actions: [
        Column(
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  label: const Text(
                    'Password',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  hintStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: Colors.black,
                  ),
                ),
                style: const TextStyle(
                  color: Colors.black,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
            ),
            ValueListenableBuilder(
              valueListenable: _errorMessage,
              builder: (context, value, child) {
                if (value.length != 0) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final statusCode = await AuthDB()
                          .deleteAccount(_passwordController.text);
                      if (statusCode == 200) {
                        final SharedPreferences _sharedPref =
                            await SharedPreferences.getInstance();
                        await _sharedPref.remove(TOKEN);
                        await _sharedPref.remove(EMAIL);
                        await _sharedPref.remove(USERNAME);
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (ctx) => AuthScreen(),
                          ),
                          (route) => false,
                        );
                        snackbarMessage(
                            context, "Account Deleted Successfully");
                      } else if (statusCode == 401) {
                        _errorMessage.value = "Incorrect password";
                      } else if (statusCode == 404) {
                        _errorMessage.value = "User not found";
                      } else {
                        _errorMessage.value = "Internal server error";
                      }
                    }
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
