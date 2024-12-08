import 'package:flutter/material.dart';
import 'package:globalchatapp/screens/signup_screen.dart';
import 'package:globalchatapp/controllers/login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  var userForm = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
      ),
      body: Form(
        key: userForm,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 130,
                  width: 130,
                  child: Image.asset("assets/images/logo.png")),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Error";
                  }
                  return null;
                },
                decoration: const InputDecoration(label: Text("Email")),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: password,
                // ignore: body_might_complete_normally_nullable
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Error";
                  }
                },
                obscureText: true,
                autocorrect: false,
                enableSuggestions: false,
                decoration: const InputDecoration(label: Text("Password")),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 45),
                            backgroundColor: const Color(0xFF002981)),
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          //code that executes if everything is right(validation).
                          if (userForm.currentState!.validate()) {
                            await LoginController.login(
                                email: email.text,
                                password: password.text,
                                context: context);

                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        child: isLoading
                            ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                "Login",
                                style: TextStyle(color: Colors.white),
                              )),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Dont have an Account?"),
                  const SizedBox(
                    width: 15,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const SignupScreen();
                        }));
                      },
                      child: const Text(
                        "Signup here!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
