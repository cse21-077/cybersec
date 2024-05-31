import 'package:cybersec/components/my_button.dart';
import 'package:cybersec/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recaptcha_v2_compat/flutter_recaptcha_v2_compat.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String passwordStrength = '';
  bool isReCaptchaVerified = false;
  bool showReCaptcha = false;
  final RecaptchaV2Controller recaptchaV2Controller = RecaptchaV2Controller();

  // Password strength checking function
  void checkPasswordStrength(String value) {
    if (value.length < 8) {
      setState(() {
        passwordStrength = 'Weak';
      });
      return;
    }
    bool hasUppercase = value.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = value.contains(RegExp(r'[a-z]'));
    bool hasDigits = value.contains(RegExp(r'[0-9]'));
    bool hasSpecialCharacters =
        value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (hasUppercase && hasLowercase && hasDigits && hasSpecialCharacters) {
      setState(() {
        passwordStrength = 'Strong';
      });
    } else {
      setState(() {
        passwordStrength = 'Medium';
      });
    }
  }

  void registerUser() {
    if (passwordStrength == 'Weak' || !isReCaptchaVerified) {
      return;
    }
    // Registration logic here
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Registration successful!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showCaptcha() {
    setState(() {
      showReCaptcha = true;
    });
  }

  void hideCaptcha() {
    setState(() {
      showReCaptcha = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  const Icon(
                    color: Color.fromARGB(255, 4, 167, 131),
                    Icons.lock,
                    size: 100,
                  ),
                  const SizedBox(height: 50),
                  Text(
                    'Create a new account',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 25),
                  MyTextField(
                    controller: usernameController,
                    hintText: 'Username',
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    onChanged: (value) {
                      checkPasswordStrength(value);
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Password Strength: $passwordStrength',
                    style: TextStyle(
                      color: passwordStrength == 'Weak'
                          ? Colors.red
                          : passwordStrength == 'Medium'
                              ? Colors.orange
                              : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),
                  MyButton(
                    onTap: isReCaptchaVerified && passwordStrength != 'Weak'
                        ? registerUser
                        : showCaptcha,
                    
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already a member?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Login now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (showReCaptcha)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: RecaptchaV2(
                      apiKey: "6LdsIewpAAAAAJt5BA_qKAWSmHCfWHCWiVx2ibTX",
                      apiSecret: "6LdsIewpAAAAAEDjZC5JWnL80mNmUYsmaBJqCoQL",
                      controller: recaptchaV2Controller,
                      onVerifiedError: (err) {
                        print(err);
                        setState(() {
                          isReCaptchaVerified = false;
                          hideCaptcha();
                        });
                      },
                      onVerifiedSuccessfully: (success) {
                        setState(() {
                          isReCaptchaVerified = success;
                          hideCaptcha();
                        });
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
