import 'package:flutter/material.dart';
import 'package:saron/Screens/account_details_screen/account_details_screen.dart';
import 'package:saron/Screens/auth_screen/auth_screen.dart';
import 'package:saron/Screens/auth_screen/forgetpassword_screen.dart';
import 'package:saron/Screens/settings_screen/widgets/custom_container.dart';
import 'package:saron/Screens/settings_screen/widgets/delete_confirmation.dart';
import 'package:saron/Screens/support_screen/support_screen.dart';
import 'package:saron/api/load_data/load_devices.dart';
import 'package:saron/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 40),
          child: Column(
            children: [
              CustomContainer(
                leadingIcon: Icons.person,
                title: "Account Details",
                trailingIcon: Icons.keyboard_arrow_right,
                onPress: () async {
                  final _sharedPref = await SharedPreferences.getInstance();
                  final _email = _sharedPref.getString(EMAIL);
                  final _username = _sharedPref.getString(USERNAME);
                  final _device = await loadDeviceList();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => AccountDetailsScreen(
                        email: _email!,
                        name: _username!,
                        devices: _device,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 30,
              ),
              CustomContainer(
                leadingIcon: Icons.logout,
                title: "Logout",
                onPress: () async {
                  final SharedPreferences _sharedPref =
                      await SharedPreferences.getInstance();
                  await _sharedPref.clear();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (ctx) => AuthScreen(),
                    ),
                    (route) => false,
                  );
                },
              ),
              SizedBox(
                height: 30,
              ),
              CustomContainer(
                leadingIcon: Icons.phone,
                title: "Help and Support",
                onPress: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => const SupportScreen(),
                )),
              ),
              SizedBox(
                height: 30,
              ),
              CustomContainer(
                leadingIcon: Icons.lock,
                title: "Reset Password",
                onPress: () async {
                  final _sharedPref = await SharedPreferences.getInstance();
                  final _email = _sharedPref.getString(EMAIL);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => ForgetPasswordScreen(
                        email: _email,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 30,
              ),
              CustomContainer(
                leadingIcon: Icons.delete,
                title: "Delete Account",
                color: Colors.red,
                onPress: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DeleteConfirmation();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
