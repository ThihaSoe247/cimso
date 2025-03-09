import 'package:cloud_firestore/cloud_firestore.dart';

class Statement {
  final String hotelName;
  final String user;
  final double amount;
  final String type;
  final String memberID;

  final DateTime date;

  Statement({
    required this.hotelName,
    required this.user,

    required this.amount,
    required this.type,
    required this.memberID,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'user': user,
      'type': type,
      'memberID': memberID,
      'date': Timestamp.fromDate(date),
    };
  }

  // Convert Firestore document snapshot to Statement object
  factory Statement.fromMap(Map<String, dynamic> map) {
    return Statement(
      hotelName: map['hotelName'],
      user: map['user'],
      amount: map['amount'].toDouble(),
      type: map['type'],
      memberID: map['memberID'],
      date: (map['date'] as Timestamp).toDate(),
    );
  }
}
