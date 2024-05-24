import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class EnrollmentItem {
  final String eventName;
  final String customMessage; // New field

  EnrollmentItem({
    required this.eventName,
    required this.customMessage, // Initialize customMessage
  });
}

class HistoryPage extends StatelessWidget {
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
        child: Center(
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
              return Center(child: Text('No history found'));
            } else {
              List<EnrollmentItem> enrollments = snapshot.data ?? [];
              enrollments = enrollments.reversed.toList(); // Reverse the list

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: enrollments.map((enrollment) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                    ),
                    padding: EdgeInsets.all(16.0),
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Event-Name: ${enrollment.eventName}', // Display eventName
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Status: ${enrollment.customMessage}', // Display custom message
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
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
  ]),
    ),
    ),
    )
    ;
  }

  Stream<List<EnrollmentItem>> fetchEnrollments() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('No user is currently logged in');
    }

    DatabaseReference resultRef = FirebaseDatabase.instance.ref('users/${user.uid}/CustomMessages');

    return resultRef.once().then((eventSnapshot) {
      List<EnrollmentItem> allEnrollments = [];

      if (eventSnapshot.snapshot.value != null) {
        Map<dynamic, dynamic> resultsData = eventSnapshot.snapshot.value as Map<dynamic, dynamic>;

        resultsData.forEach((messageId, messageData) {
          final eventName = messageData['eventName'];
          String eventNameString;

          if (eventName is int) {
            eventNameString = eventName.toString(); // Convert integer to string if necessary
          } else if (eventName is String) {
            eventNameString = eventName;
          } else {
            eventNameString = ''; // Default or error handling case
          }

          final customMessage = messageData['customMessage'] ?? ''; // Fetch customMessage

          allEnrollments.add(EnrollmentItem(
            eventName: eventNameString,
            customMessage: customMessage, // Assign customMessage
          ));
        });
      }

      return allEnrollments;
    }).asStream();
  }
}
