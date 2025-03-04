import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

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
      _nameController.text = userDoc['fullName'];
      _phoneController.text = userDoc['phoneNumber'];
      _emailController.text = userDoc['email'] ?? ''; // Email from Firestore, might not be available if not set
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
          'phoneNumber': _phoneController.text,
          'email': _emailController.text, // Storing email from user input
          'profilePicture': _profilePicUrl.isEmpty ? null : _profilePicUrl, // Save profile pic URL or null
          'memberID': user.uid, // UID as memberID
          'clientID': 'RRKUL00002', // Modify clientID logic if needed
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
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
      appBar: AppBar(title: Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Full Name'),
            ),
            SizedBox(height: 10),

            // Phone Number Text Field
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            SizedBox(height: 10),

            // Email Text Field (Editable)
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),

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
    );
  }
}
