import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/my_textfield.dart';
import '../service/firebase_service.dart';
import 'login.dart'; // After registration, navigate to login page

class RegisterPage extends StatelessWidget {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmpassword = TextEditingController();
  final TextEditingController fullName = TextEditingController();
  final TextEditingController clientID = TextEditingController();
  final TextEditingController memberID = TextEditingController();  // Reintroduced memberID

  // Registration Function
  void registerAccount(BuildContext context) async {
    if (password.text == confirmpassword.text) {
      if (email.text.isNotEmpty && password.text.isNotEmpty) {
        try {
          // Register user with Firebase Authentication
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
            email: email.text,
            password: password.text,
          );


          await FirestoreService().addMemberToFirestore(
            fullName: fullName.text,
            email: email.text,
            profilePicture: '',
            clientID: clientID.text,
            memberID: memberID.text,  // Pass memberID
          );

          // Navigate to Login Page after registration
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Registration successful!")),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${e.toString()}")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please fill all fields")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  "assets/images/cimso.jpeg",
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Register Page",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 20),

              MyTextfield(
                controller: fullName,
                hintText: "Full Name",
                obsecureText: false,
              ),
              SizedBox(height: 15),

              MyTextfield(
                controller: email,
                hintText: "Email",
                obsecureText: false,
              ),
              SizedBox(height: 15),

              Row(
                children: [
                  Expanded(
                    child: MyTextfield(
                      controller: clientID,
                      hintText: "Client ID",
                      obsecureText: false,
                    ),
                  ),
                  SizedBox(width: 15),

                  Expanded(
                    child: MyTextfield(
                      controller: memberID,
                      hintText: "MemberID",
                      obsecureText: false,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),

              MyTextfield(
                controller: password,
                hintText: "Password",
                obsecureText: true,
              ),
              SizedBox(height: 15),
              MyTextfield(
                controller: confirmpassword,
                hintText: "Confirm Password",
                obsecureText: true,
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  registerAccount(context);
                },
                child: Text("Sign Up"),
              ),

              SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? "),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text(
                      "Log In Here",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),

              Text(
                "By signing in, you agree to CiMSO Terms and Conditions, Terms of Use and Privacy Policy.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
