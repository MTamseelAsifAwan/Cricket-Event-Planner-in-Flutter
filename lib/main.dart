import 'package:flutter/material.dart';
import 'package:untitled3/Notifications.dart';
import 'package:untitled3/personalinfo.dart';
import 'package:untitled3/payment.dart';
import 'package:untitled3/eventlisting.dart';
import 'package:untitled3/Historypage2.dart';

import 'package:untitled3/policy.dart';
import 'package:untitled3/terms.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCvLEULKhHLs-j7GpfkWJoHcpa2KJSuo1s",
          authDomain: "crickyapp-f9706.firebaseapp.com",
          databaseURL: "https://crickyapp-f9706-default-rtdb.firebaseio.com",
          projectId: "crickyapp-f9706",
          storageBucket: "crickyapp-f9706.appspot.com",
          messagingSenderId: "786395538829",
          appId: "1:786395538829:web:f93e5164deaac2ec20c9c4",
          measurementId: "G-X3CNFN44EH"

      )
  );
  runApp(MyApp()); // Run your app's main widget

}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cricket Event Listing App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      initialRoute: '/start',
      routes: {
        '/start': (context) => StartPage(),
        '/About': (context) => AboutPage(),
        '/home': (context) => MyHomePage(),
        '/Login': (context) => LoginForm(),
        '/notify':(context) => NotificationsPage(),
        '/personinfo' :(context) => PersonalInfoPage(),
        '/payinfo' :(context) => HistoryPage(),
        '/listing' :(context) => MyHomePage2(),
        '/eventhistory' :(context) => HistoryPage2(),
        '/enroll' :(context) =>  EnrollmentForm(eventName: '', eventCreatorId: '', eventId: '',),
        '/policy' :(context) => PrivacyPolicyPage(),
        '/terms' :(context) => TermsAndConditionsPage(),
        '/signup' :(context) => SignupForm(), // Use SignupForm directly

      },
    );
  }
}
class StartPage extends StatelessWidget {
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
        backgroundColor:
        Colors.purple, // Set the background color to dark navy
      ),
      backgroundColor:
      Colors.purple, // Set the background color to dark navy
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Cricket Event Planner',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Set text color to white
              ),
            ),
            SizedBox(height: 20),
            Image.network(
              'https://th.bing.com/th/id/OIP.M3coMoJ7znwKtPsnTq4x8gHaKe?w=204&h=289&c=7&r=0&o=5&pid=1.7', // Add your image URL here
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10), // Set rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Welcome to Cricket Planner platform!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigate to the "/Login" route
                Navigator.pushNamed(context, "/Login");
              },
              child: Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Form',
      theme: ThemeData(
        primaryColor: Colors.blue[50],
        hintColor: Colors.white,
        scaffoldBackgroundColor: Colors.blue[200],
        textTheme: TextTheme(
          headlineSmall: TextStyle(
            fontSize: 54.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyLarge: const TextStyle(
            fontSize: 16.0,
            color: Colors.purple,
          ),
          labelLarge: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(

          labelStyle: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      home: LoginForm(),
    );
  }
}


class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.purple,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 80.0),
              Icon(
                Icons.login,
                size: 100.0,
                color: Colors.white,
              ),
              SizedBox(height: 24.0),
              Text(
                'Welcome!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.0),
              TextField(
                controller: _emailController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              _isProcessing
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _isProcessing ? null : _loginAsPlayer,
                child: Text('Login as player'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _isProcessing ? null : _loginAsEventManager,
                child: Text('Login as event manager'),
              ),
              SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/signup");
                },
                child: Text(
                    'Don\'t have an account? Sign up',
                    style: TextStyle(
                      color: Colors.white,
                    ),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loginAsPlayer() async {
    await _login(isPlayer: true);
  }

  Future<void> _loginAsEventManager() async {
    await _login(isPlayer: false);
  }

  Future<void> _login({required bool isPlayer}) async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        // Navigate to the appropriate screen based on login type
        if (isPlayer) {
          Navigator.pushNamed(context, '/home');
        } else {
          Navigator.pushNamed(context, '/listing');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed. Please try again.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed. Please try again.')),
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }
}





class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _userRef =
  FirebaseDatabase.instance.reference().child('users');

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _playerTypeController = TextEditingController();

  bool _isProcessing = false;
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup Form'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.purple,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 80.0),
              Icon(
                Icons.person_add,
                size: 100.0,
                color: Colors.white,
              ),
              SizedBox(height: 24.0),
              Text(
                'Signup!',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.0),
              TextField(
                controller: _nameController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _emailController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _phoneNumberController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _ageController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Age',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _addressController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Address',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _confirmPasswordController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _playerTypeController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Player Type',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 16.0),
              if (_imageFile != null)
                Image.file(
                  _imageFile!,
                  height: 150,
                ),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Profile Image'),
              ),
              SizedBox(height: 16.0),
              _isProcessing
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _isProcessing ? null : _register,
                child: Text('Signup'),
              ),
              SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/Login");
                },
                child: Text(
                  'Already have an account? Login',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _register() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneNumberController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _playerTypeController.text.isEmpty ||
        _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields and select an image')),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Upload the image to Firebase Storage
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child(userCredential.user!.uid + '.jpg');
      await ref.putFile(_imageFile!);
      final imageUrl = await ref.getDownloadURL();

      // Store additional user details in Firebase Realtime Database
      await _userRef.child(userCredential.user!.uid).set({
        'name': _nameController.text,
        'email': _emailController.text,
        'phoneNumber': _phoneNumberController.text,
        'age': _ageController.text,
        'address': _addressController.text,
        'playerType': _playerTypeController.text,
        'imageUrl': imageUrl,
      });

      // Clear text fields after successful registration
      _nameController.clear();
      _emailController.clear();
      _phoneNumberController.clear();
      _ageController.clear();
      _addressController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      _playerTypeController.clear();
      setState(() {
        _imageFile = null;
      });

      // Navigate to the home screen or any other screen after successful registration
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'An error occurred')),
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }
}

  class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    ProfilePage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar:  AppBar(
        title: Text(
          'Cricket Event Planner',
          style: TextStyle(
            color: Colors.white, // Set title color to white
          ),
        ),
        backgroundColor: Colors.purple, // Set the background color to dark navy
        actions: [
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
            title: Text('About1', style: TextStyle(color: Colors.black)),
            onTap: () {
              Navigator.pushNamed(context, "/About");
            },
          ),
        ],
      ),
    );
  }
}



class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: fetchAllEventsData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('No events found'));
        } else {
          List<Map<String, dynamic>> allEventData = snapshot.data ?? [];
          return ListView.builder(
            itemCount: allEventData.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> userData = allEventData[index];
              String userId = userData['userId']; // Extract userId from userData
              List<Map<String, dynamic>> eventDataList = List<Map<String, dynamic>>.from(userData['events'] ?? []);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: eventDataList.map((eventData) {
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
                    AccountHolderName: 'AccHolderName: ${eventData['AccountHolderName']}',
                    PaymentMethod: 'PaymentMethod: ${eventData['PaymentMethod']}',
                    Applicants: 'Total Applicants Applied: ${eventData['totalApplicants']}', // Use totalApplicants
                    userId: ' ${eventData['userId']}',

                    onEnrollPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EnrollmentForm(
                            eventName: eventData['eventName'],
                            eventCreatorId: userId,
                            eventId: eventId, // Pass the eventId to EnrollmentForm
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              );
            },
          );
        }
      },
    );
  }

  Stream<List<Map<String, dynamic>>> fetchAllEventsData() {
    DatabaseReference usersRef = FirebaseDatabase.instance.reference().child('users');
    return usersRef.onValue.map((event) {
      List<Map<String, dynamic>> allEventData = [];
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> userData = event.snapshot.value as Map<dynamic, dynamic>;
        userData.forEach((userId, userDataMap) {
          List<Map<String, dynamic>> eventDataList = [];
          if (userDataMap != null && userDataMap['Events'] != null) {
            Map<dynamic, dynamic> events = userDataMap['Events'];
            events.forEach((eventId, eventData) {
              Map<String, dynamic> eventDataMap = Map<String, dynamic>.from(eventData);
              eventDataMap['eventId'] = eventId; // Add eventId to eventData

              // Fetch total applicants from AllEnrollment node
              int totalApplicants = 0;
              if (userDataMap['AllEnrollment'] != null && userDataMap['AllEnrollment'][eventId] != null) {
                totalApplicants = (userDataMap['AllEnrollment'][eventId] as Map).length;
              }
              eventDataMap['totalApplicants'] = totalApplicants;

              eventDataList.add(eventDataMap);
            });
          }
          allEventData.add({'userId': userId, 'events': eventDataList.reversed.toList()});
        });
      }
      return allEventData;
    });
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
  final String Applicants;
  final String DateAndTiming;
  final String Venue;
  final String userId; // Added userId field
  final VoidCallback onEnrollPressed; // Callback for enroll button

  const EventItem({
    required this.image,
    required this.PaymentMethod,
    required this.ReceiverAccountNo,
    required this.AccountHolderName,
    required this.eventName,
    required this.eventFee,
    required this.eventDescription,
    required this.location,
    required this.Applicants,
    required this.DateAndTiming,
    required this.Venue,
    required this.userId, // Initialize userId
    required this.onEnrollPressed, // Initialize onEnrollPressed
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.purple[50],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  image,
                  width: 500,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 10.0),
                Text(
                  eventName,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  eventFee,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  eventDescription,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  location,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  DateAndTiming,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                // SizedBox(height: 10.0),
                // Text(
                //   Venue,
                //   style: TextStyle(
                //     fontSize: 16.0,
                //     fontWeight: FontWeight.bold,
                //     color: Colors.black,
                //   ),
                // ),
                SizedBox(height: 10.0),

                Text(ReceiverAccountNo,style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold, // Set font weight to bold
                  color: Colors.black, // Set text color to red
                ),),
                SizedBox(height: 10.0),

                Text(AccountHolderName,style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold, // Set font weight to bold
                  color: Colors.black, // Set text color to red
                ),),
                SizedBox(height: 10.0),

                Text(PaymentMethod,style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold, // Set font weight to bold
                  color: Colors.black, // Set text color to red
                ),),
               
                SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: onEnrollPressed, // Call onEnrollPressed callback
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple, // Background colorTe: Colors.white, // Text color
                  ),
                  child: Text('Enroll',style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}

class EnrollmentForm extends StatefulWidget {
  final String eventName;
  final String eventCreatorId;
  final String eventId; // Add eventId field

  const EnrollmentForm({
    Key? key,
    required this.eventName,
    required this.eventCreatorId,
    required this.eventId, // Initialize eventId
  }) : super(key: key);

  @override
  _EnrollmentFormState createState() => _EnrollmentFormState();
}

class _EnrollmentFormState extends State<EnrollmentForm> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _playerTypeController = TextEditingController();
  TextEditingController _paymentIdController = TextEditingController();
  TextEditingController _accountNumberController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enrollment Form'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20.0),
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(labelText: 'Full Name'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _playerTypeController,
              decoration: InputDecoration(labelText: 'Player Type'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _paymentIdController,
              decoration: InputDecoration(labelText: 'Payment ID'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _accountNumberController,
              decoration: InputDecoration(labelText: 'Account Number'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => enroll(context),
              child: Text('Enroll'),
            ),
          ],
        ),
      ),
    );
  }

  void enroll(BuildContext context) async {
    // Check if any field is empty
    if (_fullNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _playerTypeController.text.isEmpty ||
        _paymentIdController.text.isEmpty ||
        _accountNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // Get current user
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No user is currently logged in')),
      );
      return;
    }

    // Prepare enrollment data
    Map<String, dynamic> enrollmentData = {
      'eventName': widget.eventName,
      'fullName': _fullNameController.text,
      'email': _emailController.text,
      'playerType': _playerTypeController.text,
      'paymentId': _paymentIdController.text,
      'accountNumber': _accountNumberController.text,
      'userId': user.uid, // Save user's UID in enrollment data
    };

    // Send enrollment data to the relevant event under Events node
    DatabaseReference eventRef = FirebaseDatabase.instance.reference().child('users').child(widget.eventCreatorId).child('Events').child(widget.eventId).child('Enrollments');
    DatabaseReference allEnrollmentsRef = FirebaseDatabase.instance.reference().child('users').child(widget.eventCreatorId).child('AllEnrollments');

    try {
      // Save under relevant event
      await eventRef.push().set(enrollmentData);
      // Save under AllEnrollments
      await allEnrollmentsRef.push().set(enrollmentData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enrollment successful')),
      );
      // Clear text fields after successful enrollment
      _fullNameController.clear();
      _emailController.clear();
      _playerTypeController.clear();
      _paymentIdController.clear();
      _accountNumberController.clear();
    } catch (e) {
      print('Error enrolling: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}




class ProfilePage extends StatelessWidget {
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
class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white70,
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About the Cricket Event Planner App',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'The Cricket Event Planner app is a comprehensive solution designed to streamline the organization and management of cricket events. Whether it\'s arranging matches, scheduling practice sessions, or coordinating tournaments, this app offers a user-friendly platform to handle all aspects of cricket event planning. From creating teams and assigning players to managing venues and tracking scores, the Cricket Event Planner app simplifies the entire process, ensuring smooth and efficient execution of cricket events. With features tailored to the needs of cricket enthusiasts, coaches, and organizers, this app revolutionizes how cricket events are planned and executed, making it an indispensable tool for anyone involved in the cricket community.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Key Features',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '1. Event Creation: Create and manage cricket events with ease.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '2. Team Management: Form teams, assign players, and manage rosters.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '3. Venue Booking: Find and book cricket grounds or venues for your events.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '4. Score Tracking: Keep track of scores, statistics, and game progress in real-time.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Testimonials',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '“The Cricket Event Planner app has transformed the way we organize our tournaments. It\'s user-friendly and packed with features that make event management a breeze.” - John Doe, Cricket Organizer',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '“With the Cricket Event Planner app, we can focus more on playing cricket and less on the administrative work. It\'s a game-changer for our team!” - Jane Smith, Cricket Player',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
