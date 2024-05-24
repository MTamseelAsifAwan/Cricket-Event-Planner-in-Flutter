import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class PersonalInfoPage extends StatefulWidget {
  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  late List<PersonalInfoItem> personalInfoList;

  @override
  void initState() {
    super.initState();
    personalInfoList = [];
    initializeUserData();
  }

  void initializeUserData() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        fetchUserData(user.uid); // Pass UID directly to fetchUserData
      } else {
        print("No user is currently logged in.");
      }
    });
  }

  Future<void> fetchUserData(String uid) async {
    print("Using UID of current user: $uid");

    DatabaseReference userRef = FirebaseDatabase.instance.ref('users/$uid');
    try {
      DataSnapshot dataSnapshot = await userRef.get();
      if (dataSnapshot.exists && mounted) { // Check if widget is mounted before calling setState
        print("Data exists!");

        Map<dynamic, dynamic> userData = dataSnapshot.value as Map<dynamic, dynamic>;
        Map<String, dynamic> userDataMap = Map<String, dynamic>.from(userData);

        setState(() {
          personalInfoList = [
            PersonalInfoItem(label: 'Name', value: userDataMap['name'] ?? 'N/A'),
            PersonalInfoItem(label: 'Email', value: userDataMap['email'] ?? 'N/A'),
            PersonalInfoItem(label: 'Phone', value: userDataMap['phoneNumber'] ?? 'N/A'),
            PersonalInfoItem(label: 'Address', value: userDataMap['address'] ?? 'N/A'),
            PersonalInfoItem(label: 'Player Type', value: userDataMap['playerType'] ?? 'N/A'),
          ];
        });
      } else {
        print("No data found for user with UID $uid.");
      }
    } catch (e) {
      print("An error occurred while fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Information'),
        backgroundColor: Colors.purple,
      ),
      body: personalInfoList.isNotEmpty
          ? SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: personalInfoList.map((info) {
            return Container(
              color: Colors.purple,
              padding: EdgeInsets.all(16.0),
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    info.label,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    info.value,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      )
          : Center(
        child: Text("No personal information available or failed to load data."),
      ),
    );
  }
}

class PersonalInfoItem {
  final String label;
  final String value;

  PersonalInfoItem({required this.label, required this.value});
}
