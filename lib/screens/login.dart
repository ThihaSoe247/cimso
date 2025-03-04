import 'package:cimso_heckathon/screens/register_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../service/auth_service.dart';
import 'home_screen.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  "assets/images/cimso.jpeg",
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 25),
              Text(
                "Welcome to Cimso Memership",
                textAlign: TextAlign.center,
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,

                  color: Colors.black,
                ),
              ),
              SizedBox(height: 25),
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  "Log In",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 30, color: Colors.black),
                ),
              ),
              SizedBox(height: 15),
              MyTextfield(controller: email, hintText: "Enter your Email", obsecureText: false),
              SizedBox(height: 10),
              MyTextfield(controller: password, hintText: "Enter your Password", obsecureText: true),

              SizedBox(height: 20),
              MyButton(
                onTap: () async {
                  if (email.text.isEmpty || password.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please enter email and password"),
                      ),
                    );
                    return;
                  }

                  try {
                    await AuthService().signInWithEmailAndPassword(
                      email.text,
                      password.text,
                    );
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                          (route) => false, // Removes all previous routes
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Login Successful!")),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: ${e.toString()}")),
                    );
                  }
                },
                name: "Sign In",
              ),
              TextButton(onPressed: (){}, child: Text("Forget Password?",style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),)),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Not a member? "),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blue,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Text("You are now a part of an exclusive community"),
              Text("By logging in, it’s deemed that you have read and agreed to CiMSO Terms of Use and Privacy Policy.")
            ],
          ),
        ),
      ),
    );
  }
}
