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
  final TextEditingController phoneNumber = TextEditingController();

  // Registration Function
  void registerAccount(BuildContext context) async {
    if (password.text == confirmpassword.text) {
      if (email.text.isNotEmpty && password.text.isNotEmpty) {
        try {
          // Register the user with Firebase Authentication
          UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email.text,
            password: password.text,
          );

          // Now add the member details to Firestore
          await FirestoreService().addMemberToFirestore(
            fullName: fullName.text,
            phoneNumber: phoneNumber.text,
            email: email.text,
            profilePicture: '', // Use a default image or empty for now
          );

          // Navigate to Login Page after registration
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));

          // Optionally show a success message
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registration successful!")));
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all fields")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Passwords do not match")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                "Register Page",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 25),
              MyTextfield(controller: fullName, hintText: "Enter your Fullname", obsecureText: false),

              SizedBox(height: 20),
              MyTextfield(controller: email, hintText: "Email", obsecureText: false),
              SizedBox(height: 20),


              MyTextfield(controller: password, hintText: "Password", obsecureText: true),

              SizedBox(height: 20),
              MyTextfield(controller: confirmpassword, hintText: "Confirmed Password", obsecureText: true),

              SizedBox(height: 25),
              MyTextfield(controller: phoneNumber, hintText: "Enter your Phone Number", obsecureText: false),


              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  registerAccount(context); // Call registration method
                },
                child: Text("Sign Up"),
              ),
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
                          decoration: TextDecoration.underline,color: Colors.blue, fontWeight: FontWeight.bold,fontSize: 20),
                    ),
                  ),
                ],
              ),
              Text("By signing in, you agree to CiMSO Terms and Conditions, Terms of Use and Privacy Policy.")
            ],
          ),
        ),
      ),
    );
  }
}
