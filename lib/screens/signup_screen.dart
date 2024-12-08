import 'package:flutter/material.dart';
import 'package:globalchatapp/controllers/signup_controller.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var userForm = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController country = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(""),
      ),
      body: Form(
        key: userForm,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
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
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Error";
                  }
                  return null;
                },
                decoration: const InputDecoration(label: Text("Name")),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: country,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Error";
                  }
                  return null;
                },
                decoration: const InputDecoration(label: Text("Country")),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 45),
                      backgroundColor: const Color(0xFF002981)),
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    //code that executes if everything is right(validation).
                    if (userForm.currentState!.validate()) {
                      await SignupController.creatAccount(
                          email: email.text,
                          password: password.text,
                          name: name.text,
                          country: country.text,
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
                          "Sing Up",
                          style: TextStyle(color: Colors.white),
                        )),
            ],
          ),
        ),
      ),
    );
  }
}
