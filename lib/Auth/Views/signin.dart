import 'package:flutter/material.dart';
import 'package:instagrocers/Auth/Apis/authservice.dart';
import 'package:instagrocers/Gen/Textformfield.dart';
import 'package:instagrocers/Gen/custombtn.dart';
import 'package:instagrocers/Gen/customtext.dart';
import 'package:instagrocers/Home/Views/Home.dart';
import 'package:instagrocers/main.dart';



class SigninScreen extends StatefulWidget {
  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> _handleLogin() async {
    setState(() => isLoading = true);

    final authService = AuthService();
    final user =
        await authService.login(emailController.text, passwordController.text);

    setState(() => isLoading = false);

    if (user != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login Successful! Welcome, ${user.name}")),
      );
      // Navigate to the next screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login Failed! Please check your credentials.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Image.asset(
                    'assets/groceries.png',
                    fit: BoxFit.contain,
                    height: 250,
                    width: 250,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  const CustomText(
                    text:
                        "Welcome to InstaGrocers! Log in to access our store and enjoy our full range of products",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ContainerTextFormField(
                    label: "Email",
                    hintText: "Enter your email",
                    controller: emailController,
                  ),
                  SizedBox(height: 20),
                  ContainerTextFormField(
                    label: "Password",
                    hintText: "Enter your password",
                    controller: passwordController,
                    isPassword: true,
                  ),
                  SizedBox(height: 30),
                  CustomButton(
                    text: isLoading ? null : "Sign In",
                    color: Colors.orange,
                    onPressed: isLoading ? null : _handleLogin,
                    child: isLoading
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white))
                        : null,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
