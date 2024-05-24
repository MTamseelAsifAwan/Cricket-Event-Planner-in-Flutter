import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class EnrollmentItem {
  final String fullName;
  final String email;
  final String eventName;
  final String playerType;
  final String accountNumber;
  final String paymentId;
  final String userId; // New field

  EnrollmentItem({
    required this.fullName,
    required this.email,
    required this.eventName,
    required this.playerType,
    required this.accountNumber,
    required this.paymentId,
    required this.userId, // Initialize userId
  });
}

class HistoryPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'History',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder<List<EnrollmentItem>>(
              stream: fetchEnrollments(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No enrollments found'));
                } else {
                  List<EnrollmentItem> enrollments = snapshot.data ?? [];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: enrollments.map((enrollment) {
                      return Container(
                        color: Colors.purple,
                        padding: EdgeInsets.all(16.0),
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Event Enrollemnt History',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'Full Name: ${enrollment.fullName}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Email: ${enrollment.email}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Event Name: ${enrollment.eventName}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Player Type: ${enrollment.playerType}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Account Number: ${enrollment.accountNumber}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Payment ID: ${enrollment.paymentId}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Stream<List<EnrollmentItem>> fetchEnrollments() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('No user is currently logged in');
    }

    DatabaseReference allEnrollmentsRef = FirebaseDatabase.instance.ref('users/${user.uid}/AllEnrollments');

    return allEnrollmentsRef.once().then((enrollmentSnapshot) {
      List<EnrollmentItem> allEnrollments = [];

      if (enrollmentSnapshot.snapshot.value != null) {
        Map<dynamic, dynamic> enrollmentsData = enrollmentSnapshot.snapshot.value as Map<dynamic, dynamic>;

        enrollmentsData.forEach((enrollmentId, enrollmentData) {
          allEnrollments.add(EnrollmentItem(
            fullName: enrollmentData['fullName'] ?? '',
            email: enrollmentData['email'] ?? '',
            eventName: enrollmentData['eventName'] ?? '',
            playerType: enrollmentData['playerType'] ?? '',
            accountNumber: enrollmentData['accountNumber'] ?? '',
            paymentId: enrollmentData['paymentId'] ?? '',
            userId: enrollmentData['userId'] ?? '',
          ));
        });
      }

      return allEnrollments.reversed.toList(); // Reverse the list
    }).asStream();
  }

}
