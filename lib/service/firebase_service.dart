import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/member_object.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final CollectionReference members = FirebaseFirestore.instance.collection("members");
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference statements = FirebaseFirestore.instance.collection("statements");  // New statements collection

  // Fetch Member Details
  Future<Member?> fetchMemberDetails(String clientId) async {
    try {
      DocumentSnapshot doc = await members.doc(clientId).get();
      if (doc.exists) {
        return Member.fromMap(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print("Error fetching member details: $e");
    }
    return null;
  }

  // Add Member to Firestore
  Future<void> addMemberToFirestore({
    required String fullName,
    required String phoneNumber,
    required String email,
    required String profilePicture,
  }) async {
    try {
      String memberID = _auth.currentUser?.uid ?? ""; // Get the UID of the registered user

      Member newMember = Member(
        fullName: fullName,
        phoneNumber: phoneNumber,
        email: email,
        profilePicture: profilePicture,
        memberID: memberID,
        clientID: memberID,  // Use memberID as clientID
      );

      await members.doc(memberID).set(newMember.toMap());

      print("Member added successfully!");
    } catch (e) {
      print("Error adding member to Firestore: $e");
    }
  }

  // Add Statement for a User
  Future<void> addStatement({
    required String memberId,
    required String description,
    required double amount,
    required DateTime date,
  }) async {
    try {
      // Generate a unique statement ID
      String statementId = statements.doc().id; // Automatically generates a unique ID

      // Create statement data
      Map<String, dynamic> statementData = {
        'memberId': memberId,
        'description': description,
        'amount': amount,
        'date': date,
      };

      // Add the statement to Firestore
      await statements.doc(statementId).set(statementData);

      print("Statement added successfully!");
    } catch (e) {
      print("Error adding statement: $e");
    }
  }

  // Fetch Statements for a User
  Future<List<Map<String, dynamic>>> fetchStatements(String memberId) async {
    try {
      // Fetch statements where the memberId matches the given memberId
      QuerySnapshot snapshot = await statements
          .where('memberId', isEqualTo: memberId)
          .orderBy('date', descending: true)  // Order statements by date
          .get();

      // Convert the documents to a list of maps
      List<Map<String, dynamic>> statementsList = snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      return statementsList;
    } catch (e) {
      print("Error fetching statements: $e");
      return [];
    }
  }
}
