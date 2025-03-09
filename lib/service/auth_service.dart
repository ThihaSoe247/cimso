import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } catch (e) {
      throw(e);
    }
  }

  Future<UserCredential> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } catch (e) {
      throw(e);
    }
  }

  // Future<void> signOut() async {
  //   return await _auth.signOut();
  // }
}


// 'fullName': fullName,
// 'phoneNumber': phoneNumber,
// 'email': email,
// 'profilePicture': '', // Can be updated later
// 'memberID': '', // Generate member ID upon registration
// 'clientID': '',