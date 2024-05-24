import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:path/path.dart' as path; // Importing path.dart with an alias
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_app_check/firebase_app_check.dart';


class MyHomePage2 extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage2> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage2(),
    AddEventPage(),
    ProfilePage2(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cricket Event Planner',
          style: TextStyle(
            color: Colors.white, // Set title color to white
          ),
        ),
        backgroundColor: Colors.purple, // Set the background color to dark navy
        actions: [
          IconButton(
            icon: Icon(Icons.notifications), // Notification icon
            color: Colors.white, // Set icon color to white
            onPressed: () {
              Navigator.pushNamed(context, "/notify");
            },
          ),
          IconButton(
            icon: Icon(Icons.logout), // Logout icon
            color: Colors.white, // Set icon color to white
            onPressed: () async {
              await FirebaseAuth.instance.signOut(); // Sign out the user
              Navigator.pushNamedAndRemoveUntil(context, '/Login', (route) => false); // Navigate to login page and remove all routes
            },
          ),
        ],
      ),

      body: _pages[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        onTap: _onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Add Event',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      drawer: AppDrawer(),
    );
  }
}


class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  late String userName;
  late String userEmail;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference userRef = FirebaseDatabase.instance.ref('users/${user.uid}');
      try {
        DataSnapshot dataSnapshot = await userRef.get();
        if (dataSnapshot.exists) {
          Map<dynamic, dynamic> userData = dataSnapshot.value as Map<dynamic, dynamic>;
          setState(() {
            userName = userData['name'] ?? '';
            userEmail = userData['email'] ?? '';
          });
        }
      } catch (e) {
        print("An error occurred while fetching user data: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.purple[50],
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.purple,
            ),
            accountName: Text(
              userName.isNotEmpty ? userName : 'User Name',
              style: TextStyle(color: Colors.white),
            ),
            accountEmail: Text(
              userEmail.isNotEmpty ? userEmail : 'user@example.com',
              style: TextStyle(color: Colors.white),
            ),
          ),

          ListTile(
            leading: Icon(Icons.home, color: Colors.black),
            title: Text('About', style: TextStyle(color: Colors.black)),
            onTap: () {
              Navigator.pushNamed(context, "/About");
            },
          ),
        ],
      ),
    );
  }
}

class HomePage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: fetchEventData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('No events found'));
        } else {
          List<Map<String, dynamic>> eventDataList = snapshot.data ?? [];
          return ListView.builder(
            itemCount: eventDataList.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> eventData = eventDataList[index];
              String userId = eventData['userId']; // Extract userId from eventData
              String eventId = eventData['eventId']; // Extract eventId from eventData
              return EventItem(
                image: '${eventData['imageUrl']}',
                eventName: 'Event Name: ${eventData['eventName']}',
                eventFee: 'Event Fee: ${eventData['fee']}',
                eventDescription: 'Event Description: ${eventData['description']}',
                location: 'Location: ${eventData['location']}',
                DateAndTiming: 'DateAndTiming: ${eventData['timing']}',
                Venue: 'Venue: ${eventData['venue']}',
                ReceiverAccountNo: 'ReceiverAccountNo: ${eventData['ReceiverAccountNo']}',
                AccountHolderName: 'AccountHolderName: ${eventData['AccountHolderName']}',
                PaymentMethod: 'PaymentMethod: ${eventData['PaymentMethod']}',
                Applicants: 'Total Applicants Applied: ${eventData['applicants']}',
                userId: userId, // Pass userId to EventItem
                onDelete: () {
                  deleteEvent(userId, eventId); // Call deleteEvent function with userId and eventId
                },
              );
            },
          );
        }
      },
    );
  }

  Stream<List<Map<String, dynamic>>> fetchEventData() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    DatabaseReference userEventsRef = FirebaseDatabase.instance.ref('users/${user.uid}/Events');
    return userEventsRef.onValue.map((event) {
      List<Map<String, dynamic>> eventDataList = [];
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> values = Map<dynamic, dynamic>.from(event.snapshot.value as Map);
        values.forEach((key, value) {
          Map<String, dynamic> eventData = Map<String, dynamic>.from(value);
          eventData['userId'] = user.uid; // Set userId to the current user's ID
          eventData['eventId'] = key; // Add eventId to eventData
          eventDataList.add(eventData);
        });
      }
      return eventDataList;
    });
  }

  void deleteEvent(String userId, String eventId) {
    DatabaseReference eventRef = FirebaseDatabase.instance.ref('users/$userId/Events/$eventId');
    eventRef.remove();
  }
}

class EventItem extends StatelessWidget {
  final String image;
  final String eventName;
  final String eventFee;
  final String ReceiverAccountNo;
  final String AccountHolderName;
  final String PaymentMethod;
  final String eventDescription;
  final String location;
  final String DateAndTiming;
  final String Venue;
  final String Applicants;
  final String userId; // Added userId
  final VoidCallback onDelete; // Added onDelete callback

  EventItem({
    required this.image,
    required this.eventName,
    required this.PaymentMethod,
    required this.ReceiverAccountNo,
    required this.AccountHolderName,
    required this.eventFee,
    required this.eventDescription,
    required this.location,
    required this.DateAndTiming,
    required this.Venue,
    required this.Applicants,
    required this.userId,
    required this.onDelete, // Added onDelete
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Image.network(image),
          ListTile(
            title: Text(eventName,style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold, // Set font weight to bold
              color: Colors.black, // Set text color to red
            ),),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(eventFee,style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold, // Set font weight to bold
                  color: Colors.black, // Set text color to red
                ),),
                Text(eventDescription,style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold, // Set font weight to bold
                  color: Colors.black, // Set text color to red
                ),),
                Text(location,style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold, // Set font weight to bold
                  color: Colors.black, // Set text color to red
                ),),
                Text(DateAndTiming,style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold, // Set font weight to bold
                  color: Colors.black, // Set text color to red
                ),),
                // Text(Venue,style: TextStyle(
                //   fontSize: 16,
                //   fontWeight: FontWeight.bold, // Set font weight to bold
                //   color: Colors.black, // Set text color to red
                // ),),
                Text(ReceiverAccountNo,style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold, // Set font weight to bold
                  color: Colors.black, // Set text color to red
                ),),
                Text(AccountHolderName,style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold, // Set font weight to bold
                  color: Colors.black, // Set text color to red
                ),),
                Text(PaymentMethod,style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold, // Set font weight to bold
                  color: Colors.black, // Set text color to red
                ),),
                Text(Applicants,style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold, // Set font weight to bold
                  color: Colors.black, // Set text color to red
                ),),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.purple, // Set icon color to red
              ),
              onPressed: onDelete, // Call onDelete callback when pressed
            ),

          ),
        ],
      ),
    );
  }
}



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

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'New Enrollment',
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
                            SizedBox(height: 8),
                            Text(
                              'User ID: ${enrollment.userId}', // Display userId
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // Handle confirm action
                                    updateUserData(enrollment.userId, enrollment.eventName, 'Selected');
                                  },
                                  icon: Icon(Icons.check),
                                  label: Text(
                                    'Confirm',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // Handle reject action
                                    updateUserData(enrollment.userId, enrollment.eventName, 'Rejected');
                                  },
                                  icon: Icon(Icons.close),
                                  label: Text(
                                    'Reject',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                ),
                              ],
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

    DatabaseReference eventsRef = FirebaseDatabase.instance.ref('users/${user.uid}/Events');

    return eventsRef.once().then((eventSnapshot) {
      List<EnrollmentItem> allEnrollments = [];

      if (eventSnapshot.snapshot.value != null) {
        Map<dynamic, dynamic> eventsData = eventSnapshot.snapshot.value as Map<dynamic, dynamic>;

        eventsData.forEach((eventId, eventData) {
          if (eventData['Enrollments'] != null) {
            Map<dynamic, dynamic> enrollmentsData = eventData['Enrollments'];

            enrollmentsData.forEach((enrollmentId, enrollmentData) {
              allEnrollments.add(EnrollmentItem(
                fullName: enrollmentData['fullName'] ?? '',
                email: enrollmentData['email'] ?? '',
                eventName: eventData['eventName'] ?? '', // corrected
                playerType: enrollmentData['playerType'] ?? '',
                accountNumber: enrollmentData['accountNumber'] ?? '',
                paymentId: enrollmentData['paymentId'] ?? '',
                userId: enrollmentData['userId'] ?? '', // Assign userId
              ));
            });
          }
        });
      }

      return allEnrollments.reversed.toList(); // Reverse the list
    }).asStream();
  }

  void updateUserData(String userId, String eventName, String customMessage) {
    DatabaseReference userRef = FirebaseDatabase.instance.ref('users/$userId/CustomMessages').push();
    print("Updating path: ${userRef.path}"); // This will show the exact path being updated

    Map<String, dynamic> messageData = {
      'eventName': eventName,
      'customMessage': customMessage,
    };

    userRef.set(messageData);
  }
}


class AddEventPage extends StatefulWidget {
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _AccountHolderNameController =
  TextEditingController();
  final TextEditingController _PaymentMethodController =
  TextEditingController();
  final TextEditingController _ReceiverAccountNoController =
  TextEditingController();
  final TextEditingController _feeController = TextEditingController();
  final TextEditingController _descriptionController =
  TextEditingController();
  final TextEditingController _timingController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();
  final DatabaseReference _eventsRef =
  FirebaseDatabase.instance.ref('Events');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File? _eventImage;
  bool _isLoading = false;

  Future<void> _addEventToDatabase() async {
    setState(() {
      _isLoading = true; // Show loader
    });

    User? user = _auth.currentUser;
    if (user == null) {
      print('No user is currently logged in.');
      return;
    }

    String eventName = _eventNameController.text;
    String AccountHolderName = _AccountHolderNameController.text;
    String PaymentMethod = _PaymentMethodController.text;
    String ReceiverAccountNo = _ReceiverAccountNoController.text;
    String location = _locationController.text;
    String fee = _feeController.text;
    String description = _descriptionController.text;
    String timing = _timingController.text;
    String venue = _venueController.text;
    String userId = user.uid;

    DatabaseReference userEventsRef =
    FirebaseDatabase.instance.ref('users/$userId/Events');
    DatabaseReference eventsRef = FirebaseDatabase.instance.ref('Events');

    Map<String, dynamic> eventData = {
      'eventName': eventName,
      'location': location,
      'fee': fee,
      'description': description,
      'timing': timing,
      'venue': venue,
      'ReceiverAccountNo': ReceiverAccountNo,
      'PaymentMethod': PaymentMethod,
      'AccountHolderName': AccountHolderName,
      'userId': userId,
    };

    String? imageUrl;
    if (_eventImage != null) {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}');
      UploadTask uploadTask = storageReference.putFile(_eventImage!);
      await uploadTask.whenComplete(() async {
        imageUrl = await storageReference.getDownloadURL();
        print('Image URL: $imageUrl');
        eventData['imageUrl'] = imageUrl;

        await userEventsRef.push().set(eventData).then((_) {
          _eventNameController.clear();
          _locationController.clear();
          _feeController.clear();
          _descriptionController.clear();
          _timingController.clear();
          _venueController.clear();
          _ReceiverAccountNoController.clear();
          _PaymentMethodController.clear();
          _AccountHolderNameController.clear();
          _eventImage = null;
          print('Event added successfully to user\'s events.');
        }).catchError((error) {
          print('Error adding event to user\'s events: $error');
        });

        await eventsRef.push().set(eventData).then((_) {
          print('Event added successfully to Events.');
        }).catchError((error) {
          print('Error adding event to Events: $error');
        });
      });
    } else {
      await userEventsRef.push().set(eventData).then((_) {
        _eventNameController.clear();
        _locationController.clear();
        _feeController.clear();
        _descriptionController.clear();
        _timingController.clear();
        _venueController.clear();
        print('Event added successfully to user\'s events.');
      }).catchError((error) {
        print('Error adding event to user\'s events: $error');
      });

      await eventsRef.push().set(eventData).then((_) {
        print('Event added successfully to Events.');
      }).catchError((error) {
        print('Error adding event to Events: $error');
      });
    }

    setState(() {
      _isLoading = false; // Hide loader
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Event added successfully!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile =
    await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _eventImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Event'),
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(), // Loader
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: _getImage,
                  child: Text('Select Image'),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _eventNameController,
                decoration: InputDecoration(
                  labelText: 'Event Name',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _timingController,
                decoration: InputDecoration(
                  labelText: 'Timing',
                ),
              ),
              // SizedBox(height: 16),
              // TextField(
              //   controller: _venueController,
              //   decoration: InputDecoration(
              //     labelText: 'Venue',
              //   ),
              // ),
              SizedBox(height: 16),
              TextField(
                controller: _feeController,
                decoration: InputDecoration(
                  labelText: 'Fee',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _ReceiverAccountNoController,
                decoration: InputDecoration(
                  labelText: 'Receiver Account No',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _PaymentMethodController,
                decoration: InputDecoration(
                  labelText: 'Payment Method',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _AccountHolderNameController,
                decoration: InputDecoration(
                  labelText: 'Account Holder Name',
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _addEventToDatabase,
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class ProfilePage2 extends StatelessWidget {
  final DatabaseReference _userRef = FirebaseDatabase.instance.reference().child('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> _getUserData() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final DatabaseEvent event = await _userRef.child(user.uid).once();
      final DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        return data;
      } else {
        throw Exception('User data not found');
      }
    } else {
      throw Exception('No user logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('User data not available'));
          } else {
            final userData = snapshot.data!;
            final imageUrl = userData['imageUrl'] ?? 'assets/profile1.jpg';
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: imageUrl.startsWith('http')
                          ? NetworkImage(imageUrl)
                          : AssetImage(imageUrl) as ImageProvider,
                      radius: 50,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, "/personinfo");
                      },
                      icon: Icon(Icons.person, color: Colors.black),
                      label: Text(
                        'Personal information',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, "/eventhistory");
                      },
                      icon: Icon(Icons.history, color: Colors.black),
                      label: Text(
                        'History',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, "/policy");
                      },
                      icon: Icon(Icons.privacy_tip, color: Colors.black),
                      label: Text(
                        'Privacy policy',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, "/terms");
                      },
                      icon: Icon(Icons.description, color: Colors.black),
                      label: Text(
                        'Terms and conditions',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}