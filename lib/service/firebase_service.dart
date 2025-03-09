import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/hotel.dart';
import '../model/member_object.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../statements/statement.dart';

class FirestoreService {
  final CollectionReference members = FirebaseFirestore.instance.collection("members");
  final FirebaseAuth _auth = FirebaseAuth.instance;


  // Fetch Member Details
  Future<Member?> fetchMemberDetails() async {
    try {
      String? userID = _auth.currentUser?.uid; // Get the currently logged-in user's UID
      if (userID == null) return null;

      DocumentSnapshot doc = await members.doc(userID).get();
      if (doc.exists) {
        return Member.fromMap(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {

    }
    return null;
  }

  // Add Member to Firestore (Without using memberID)
  Future<void> addMemberToFirestore({
    required String fullName,
    required String email,
    required String profilePicture,
    required String clientID,
    required String memberID,
  }) async {
    try {
      String? userID = _auth.currentUser?.uid; // Get Firebase Auth UID
      if (userID == null) {
        return;
      }

      Member newMember = Member(
        fullName: fullName,
        email: email,
        profilePicture: profilePicture,
        memberID: memberID, // Store the Firebase UID in memberID field
        clientID: clientID,
      );

      await members.doc(userID).set(newMember.toMap()); // Store using UID

    } catch (e) {
      return;
    }
  }

  // Save Hotel for User
  Future<void> saveHotelForUser(Hotel hotel) async {
    try {
      String? userID = _auth.currentUser?.uid;
      if (userID == null) {
        return;
      }
      CollectionReference userHotels = members.doc(userID).collection("hotels");

      await userHotels.add({
        "name": hotel.name,
        "location": hotel.location,
        "image": hotel.image,
        "price": hotel.price,
        "type": hotel.type,
      });

    } catch (e) {
      print("Error saving hotel: $e");
    }
  }

  // Save Booking Receipt for User (Added function)
  Future<void> saveReceiptForUser({
    required String hotelName,
    required String location,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    required int guests,
    required String bedType,
    required bool breakfastIncluded,
    required double totalPrice,
  }) async {
    try {
      String? userID = _auth.currentUser?.uid;
      if (userID == null) {
        return;
      }
      CollectionReference userReservations = members.doc(userID).collection("reservations");

      await userReservations.add({
        "hotelName": hotelName,
        "location": location,
        "checkInDate": checkInDate,
        "checkOutDate": checkOutDate,
        "guests": guests,
        "bedType": bedType,
        "breakfastIncluded": breakfastIncluded,
        "totalPrice": totalPrice,
        "bookingDate": FieldValue.serverTimestamp(),
        "completed": false,
      });

    } catch (e) {
    }
  }
  Future<List<Map<String, dynamic>>> fetchReservations() async {
    List<Map<String, dynamic>> reservationsList = [];
    final CollectionReference reservations =
    FirebaseFirestore.instance.collection("reservations");
    try {
      String? userID = _auth.currentUser?.uid; // Get Firebase Auth UID
      if (userID == null) {
        return reservationsList;
      }

      QuerySnapshot querySnapshot = await reservations
          .where("userID", isEqualTo: userID)
          .get(); // Assuming reservations have a "userID" field

      for (var doc in querySnapshot.docs) {
        reservationsList.add(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
    }
    return reservationsList;
  }

  Future<void> saveStatementForUser(Statement statement) async {
    String? userID = _auth.currentUser?.uid; // Get Firebase Auth UID

    if (userID == null) {
      return;
    }

    CollectionReference userStatements = members.doc(userID).collection("statements");

    try {
      await userStatements.add({
        "hotelName": statement.hotelName,
        "user":statement.user,
        "amount": statement.amount,
        "type": statement.type,
        "memberID": statement.memberID,
        "date": Timestamp.fromDate(statement.date),
      });

    } catch (e) {
      print("Error saving statement: $e");
    }
  }

  Future<List<Statement>> fetchStatements(String userID) async {
    List<Statement> statementsList = [];
    try {
      String? authUserID = _auth.currentUser?.uid; // Get Firebase Auth UID
      if (authUserID == null) {
        return statementsList;
      }
      final CollectionReference statements =
      FirebaseFirestore.instance.collection("statements");

      QuerySnapshot querySnapshot = await statements
          .where("userID", isEqualTo: userID) // Assuming statements are linked to a memberID
          .get();

      // Iterate through the fetched documents and convert them to Statement objects
      for (var doc in querySnapshot.docs) {
        statementsList.add(Statement.fromMap(doc.data() as Map<String, dynamic>));
      }
    } catch (e) {
    }
    return statementsList;
  }


}
