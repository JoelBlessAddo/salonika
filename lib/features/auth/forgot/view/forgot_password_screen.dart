import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:salonika/features/auth/auth_view_model/auth_vm.dart';
import 'package:salonika/utils/colors.dart';
import 'package:salonika/utils/customContiner.dart';
import 'package:salonika/utils/custom_text_field.dart';
import 'package:salonika/utils/navigator.dart';
import 'package:toast/toast.dart';

import '../../login/view/login.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        customNavigator(context, Login());
        return false;
      },
      child: Scaffold(
        backgroundColor: WHITE,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    'Forgot Password',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Happens to the best of us. Let\'s recover your account.',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 48),
                  Text(' Email', style: TextStyle(fontSize: 13, color: BLACK)),
                  CustomTextField(
                    controller: _emailController,
                    hintText: "example@mail.com",
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Email is required";
                      }
                      if (!value.contains('@')) return "Enter a valid email";
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      label: 'Send OTP',
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            await Provider.of<AuthViewModel>(
                              context,
                              listen: false,
                            ).resetPassword(_emailController.text.trim());

                            Toast.show(
                              'OTP sent to your email',
                              backgroundColor: GREEN,
                            );

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          } catch (e) {
                            Toast.show(
                              'Something went wrong. Try again.',
                              backgroundColor: RED,
                            );
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    },
                    child: const Text('Back'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
