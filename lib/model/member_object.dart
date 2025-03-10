class Member {
  final String fullName;
  final String email;
  final String profilePicture;
  final String memberID;
  final String clientID;

  Member({
    required this.fullName,
    required this.email,
    required this.profilePicture,
    required this.memberID,
    required this.clientID,
  });

  // Convert Member to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'profilePicture': profilePicture,
      'memberID': memberID,
      'clientID': clientID,
    };
  }

  // Create Member from Map (Firestore Data)
  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      profilePicture: map['profilePicture'] ?? '',
      memberID: map['memberID'] ?? '',
      clientID: map['clientID'] ?? '',
    );
  }
}
