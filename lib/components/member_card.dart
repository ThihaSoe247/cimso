import 'package:flutter/material.dart';

import '../model/member_object.dart';


class MemberCard extends StatelessWidget {
  final Member member;

  const MemberCard({Key? key, required this.member}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      color: Colors.blueAccent, // Customize background color
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Membership Card",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("Name: ${member.fullName}", style: TextStyle(color: Colors.white)),
            Text("Client ID: ${member.clientID}", style: TextStyle(color: Colors.white)),
            Text("Membership ID: ${member.memberID}", style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}