import 'package:basecode/screens/DashboardScreen.dart';
import 'package:basecode/screens/LoginScreen.dart';
import 'package:basecode/model/User.dart';
import 'package:basecode/services/DatabaseService.dart';
import 'package:basecode/services/LocalStorageService.dart';
import 'package:basecode/widgets/CustomTextFormField.dart';
import 'package:basecode/widgets/PasswordField.dart';
import 'package:basecode/widgets/PrimaryButton.dart';
import 'package:basecode/widgets/SecondaryButton.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'ForgotPasswordScreen.dart';

class RegistrationScreen extends StatefulWidget {
  static String routeName = "/registration";
  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}


class RegistrationScreenState extends State<RegistrationScreen> {
  DatabaseService _databaseService = DatabaseService();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  final fname = TextEditingController();
  final lname= TextEditingController();
  final email = TextEditingController();
  final pass = TextEditingController();
  final confirmpass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomTextFormField(
                      labelText: "First Name",
                      hintText:
                          "First Name must have a minimum of 4 characters.",
                      iconData: FontAwesomeIcons.user,
                      controller: fname,
                      ),
                  SizedBox(
                    height: 20.0,
                  ),
                  CustomTextFormField(
                      labelText: "Last Name",
                      hintText:
                          "First Name must have a minimum of 4 characters.",
                      iconData: FontAwesomeIcons.user,
                      controller: lname,
                      ),
                  SizedBox(
                    height: 20.0,
                  ),
                  CustomTextFormField(
                      labelText: "Email",
                      hintText: "Enter a valid email.",
                      iconData: FontAwesomeIcons.solidEnvelope,
                      controller: email,
                      ),
                  SizedBox(
                    height: 20.0,
                  ),
                  PasswordField(
                      obscureText: _obscurePassword,
                      onTap: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      labelText: "Password",
                      hintText: "Enter your password",
                      controller: pass,
                      ),
                  SizedBox(
                    height: 20.0,
                  ),
                  PasswordField(
                      obscureText: _obscureConfirmPassword,
                      onTap: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                      labelText: "Confirm Password",
                      hintText: "Your passwords must match.",
                      controller: confirmpass,
                      ),
                  SizedBox(
                    height: 20.0,
                  ),
                  PrimaryButton(
                      text: "Register",
                      iconData: FontAwesomeIcons.solidFolder,
                      onPress: register),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SecondaryButton(
                          text: "Already have an account? Login",
                          onPress: () {
                            Get.offNamed(LoginScreen.routeName);
                          }),
                      SecondaryButton(
                          text: "Forgot Password?",
                          onPress: () {
                            Get.toNamed(ForgotPasswordScreen.routeName);
                          }),
                    ],
                  ),
                ],
              )),
            ),
          ),
        ),
      ),
    );
  }

  
  register() async {
    setState(() {
      _isLoading = true;
    });

    var user = User(fname.text,lname.text,email.text,pass.value.text);
    
    var result = await _databaseService.registerUser(user);

    if(result != null){
      LocalStorageService.setName(result.user.displayName);
      LocalStorageService.setUid(result.user.uid);
      LocalStorageService.setUid(result.user.refreshToken);

      Get.offNamed(DashboardScreen.routeName);
    }
    setState(() {
      _isLoading = false;
    });
  }
}
