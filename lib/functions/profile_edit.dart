import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  // Text editing controllers for name, phone number, and email
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _memberIDController = TextEditingController();
  final TextEditingController _clientIDController = TextEditingController();

  String _profilePicUrl = ''; // Store the profile picture URL or file path
  bool _isLoading = false; // Flag to handle loading state

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load current user data from Firestore
  _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('members').doc(user.uid).get();

      // Set data to controllers
      _nameController.text = userDoc['fullName'] ?? '';
      _emailController.text = userDoc['email'] ?? ''; // Email from Firestore
      _memberIDController.text = userDoc['memberID'] ?? ''; // Fetch memberID
      _clientIDController.text = userDoc['clientID'] ?? ''; // Fetch clientID
      _profilePicUrl = userDoc['profilePicture'] ?? ''; // Default to empty string if no profile picture

      setState(() {});
    }
  }

  // Update the profile data in Firestore
  _updateProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Update Firestore with new data
        await _firestore.collection('members').doc(user.uid).update({
          'fullName': _nameController.text,
          'email': _emailController.text, // Storing email from user input
          'profilePicture': _profilePicUrl.isEmpty ? null : _profilePicUrl, // Save profile pic URL or null
          'memberID': _memberIDController.text, // Saving memberID
          'clientID': _clientIDController.text, // Saving clientID
        });

        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully')));
      }
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Pick profile picture from gallery
  _pickProfilePicture() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profilePicUrl = pickedFile.path; // Set the picked image path
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),        backgroundColor: Colors.white,
      ),
      body: Container(
        color:Colors.lightGreen,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Display Membership Card
              SizedBox(height: 20), // Add some spacing between card and other elements

              // Profile Picture Section
              GestureDetector(
                onTap: _pickProfilePicture, // Pick picture on tap
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue,
                  backgroundImage: _profilePicUrl.isEmpty
                      ? AssetImage('assets/images/img.png') // Use default image if no profile pic
                      : FileImage(File(_profilePicUrl)) as ImageProvider,
                ),
              ),
              SizedBox(height: 20),

              // Full Name Text Field
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 10),

              // Email Text Field (Editable)
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Client ID Text Field
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _clientIDController,
                  decoration: InputDecoration(
                    labelText: 'Client ID',
                    border: InputBorder.none,
                  ),
                  enabled: false, // Disable editing of Client ID
                ),
              ),
              SizedBox(height: 10),

              // Member ID Text Field
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _memberIDController,
                  decoration: InputDecoration(
                    labelText: 'Member ID',
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 10),

              // Membership Card display
              Card(
                elevation: 5.0,
                color: Color(0xFFE8F5E9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/cimsocircle.jpeg",
                        width: 130,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _nameController.text,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF388E3C),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Member ID: ${_memberIDController.text}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            "Client ID: ${_clientIDController.text}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Save Changes Button
              ElevatedButton(
                onPressed: _isLoading ? null : _updateProfile,
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
