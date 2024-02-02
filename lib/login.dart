import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:h3devs/homePage/homePage.dart';
import 'package:h3devs/register.dart';
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late String error;
  bool _isObscure = true;

  bool _rememberMe = false;
  // Google sign-in
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  // Facebook login
  FacebookAuth _facebookAuth = FacebookAuth.instance;
  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    error = "";
    
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 700;
    final isMobile = !kIsWeb;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: isMobile
          ? Color.fromARGB(255, 255, 255, 255)
          : Color.fromARGB(255, 247, 246, 246),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 1300),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: isWeb
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 30),
                                Image.asset(
                                  'assets/images/phone.png',
                                  height: 900,
                                  width: 700,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 30, 50),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(
                                  color: Colors
                                      .black, // Set the color of the border
                                  width: 2.0, // Set the width of the border
                                ),
                              ),
                              child: Card(
                                elevation: 3,
                                color: Color.fromARGB(255, 247, 246, 246),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 40, 20, 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Image.asset(
                                        'assets/images/logo1.png',
                                        height:
                                            100, // Adjust the height as needed
                                        width:
                                            100, // Adjust the width as needed
                                      ),
                                      const SizedBox(height: 30),
                                      Center(
                                        child: RichText(
                                          textAlign: TextAlign.left,
                                          text: TextSpan(
                                            style: GoogleFonts.ubuntu(
                                              // Use the Google Fonts style
                                              color: Color(0xFF0D47A1),
                                              fontSize: 25,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: 'CITY ',
                                              ),
                                              TextSpan(
                                                text: 'LOADS',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      Center(
                                        child: Text(
                                          'Worlds Properties',
                                          style: GoogleFonts.ubuntu(
                                            // Use the Google Fonts style
                                            color: Color(0xFF0D47A1),
                                            fontSize: 20,
                                            letterSpacing: 3.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      TextField(
                                        controller: usernameController,
                                        decoration: const InputDecoration(
                                          labelText: 'Email Address',
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      TextField(
                                        controller: passwordController,
                                        obscureText: _isObscure,
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _isObscure
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _isObscure = !_isObscure;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      CheckboxListTile(
                                        title: const Text('Remember Me'),
                                        contentPadding: const EdgeInsets.only(
                                            left: 0, top: 0),
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        value: _rememberMe,
                                        onChanged: (value) {
                                          setState(() {
                                            _rememberMe = value!;
                                          });
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: GestureDetector(
                                          onTap: () {
                                            // Implement the logic for "Forgot Password" here
                                            print('Forgot Password tapped');
                                          },
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              'Forgot Password?',
                                              style: TextStyle(
                                                color: Color(0xFF0D47A1),
                                                fontSize: 16,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                    ElevatedButton(
  onPressed: () async {
    await _loginUser(); // Call the _loginUser method when the button is pressed
  },
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(
      Color.fromARGB(255, 38, 58, 88),
    ),
    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
      EdgeInsets.symmetric(vertical: 20, horizontal: 1),
    ),
    textStyle: MaterialStateProperty.all<TextStyle>(
      TextStyle(fontSize: 20),
    ),
  ),
  child: Text(
    'Sign in',
    style: GoogleFonts.ubuntu(
      color: Color.fromARGB(255, 255, 255, 255),
      fontSize: 20,
      letterSpacing: 3.0,
      fontWeight: FontWeight.bold,
    ),
    textAlign: TextAlign.left,
  ),
),

                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Divider(
                                              color: Colors.black,
                                              height: 36,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Text(
                                              'or',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Divider(
                                              color: Colors.black,
                                              height: 36,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                   
    ElevatedButton.icon(
      onPressed: _signInWithGoogle,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
            Color.fromARGB(255, 255, 7, 7)),
      ),
      icon: Icon(Icons.g_mobiledata_rounded),
      label: Text('Google'),
    ),
    SizedBox(width: 10),
    ElevatedButton.icon(
      onPressed: _signInWithFacebook,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
      ),
      icon: Icon(Icons.facebook),
      label: Text('Facebook'),
    ),

                                        ],
                                      ),
                                      Text(
                                        error,
                                        style: const TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),

                                      GestureDetector(
                                        onTap: () {
                                          _showAgreementDialog(
                                              context); // Show the Agreement dialog
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(height: 35),
                                              Text(
                                                "Don't have an account?",
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 20,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                'Sign Up',
                                                style: TextStyle(
                                                  color: Color(0xFF0D47A1),
                                                  fontSize: 20,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.black,
                                        height: 36,
                                      ),

                                      Center(
                                        child: const Text(
                                          'Get the App',
                                          style: TextStyle(
                                            color: Color(0xFF0D47A1),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),

                                      // Add options for gesture detection
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              // Navigate to Apple Store
                                              print('Navigate to Apple Store');
                                            },
                                            child: Image.asset(
                                              'assets/images/apple.png',
                                              height: 100,
                                              width: 200,
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          GestureDetector(
                                            onTap: () {
                                              // Navigate to Play Store
                                              print('Navigate to Play Store');
                                            },
                                            child: Image.asset(
                                              'assets/images/google.png',
                                              height: 100,
                                              width: 200,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 60),
                    ),
            ),
          ),
        ),
      ),
    );
  }
  
 // Remove the 'final' keyword from the declaration

Future<void> _loginUser() async {
  try {
    // Sign in user with email and password
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: usernameController.text,
      password: passwordController.text,
    );

    // Login successful, navigate to another page or perform additional actions
    _redirectToNewPage(); // Add this line to redirect to a new page
    print('Login Successful!');
  } catch (error) {
    // Handle login errors
    setState(() {
      this.error = 'Login failed: $error'; // Use 'this.error' to refer to the instance variable
    });
    print('Login failed: $error');
  }
}



  Future<void> _signInWithGoogle() async {
      try {
        await _googleSignIn.signIn();
        // Add logic for successful Google sign-in
        _redirectToNewPage();
        print('Google Sign-In Successful. User: ${_googleSignIn.currentUser}');
      } catch (error) {
        print('Google Sign-In Error: $error');
        // Handle error
      }
    }

    // Implement the Facebook login method
    Future<void> _signInWithFacebook() async {
      try {
        final LoginResult result = await _facebookAuth.login();
        if (result.status == LoginStatus.success) {
          // Add logic for successful Facebook login
          _redirectToNewPage();
          print('Facebook Login Successful. Token: ${result.accessToken?.token}');
        } else {
          // Handle error
          print('Facebook Login Error: ${result.message}');
        }
      } catch (error) {
        print('Facebook Login Error: $error');
        // Handle error
      }
    }

    // ...

    // New method to redirect to a new page
    void _redirectToNewPage() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MyHomePage(), // Replace YourNewPage with the actual page you want to navigate to.
        ),
      );
    }
  }

  void _showAgreementDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Terms and Conditions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Text('Sure naka ani?'),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('No', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegistrationPage()),
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: Text('Yes', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}

