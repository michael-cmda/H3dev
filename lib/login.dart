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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: isMobile
          ? const Color.fromARGB(255, 255, 255, 255)
          : const Color.fromARGB(255, 247, 246, 246),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
                constraints: const BoxConstraints(maxWidth: 1300),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      visible: screenWidth >= 990,
                      child: Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 30),
                              Visibility(
                                visible: screenWidth >= 990,
                                child: Image.asset(
                                  'assets/images/phone.png',
                                  height: 900,
                                  width: 700,
                                ),
                              ),
                            ],
                          ),
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
                              color:
                                  Colors.black, // Set the color of the border
                              width: 2.0, // Set the width of the border
                            ),
                          ),
                          child: Card(
                            elevation: 3,
                            color: const Color.fromARGB(255, 247, 246, 246),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(40, 40, 20, 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Image.asset(
                                    'assets/images/logo_nobg.png',
                                    height: 100, // Adjust the height as needed
                                    width: 100, // Adjust the width as needed
                                  ),

                                  const SizedBox(height: 30),
                                  Center(
                                    child: RichText(
                                      textAlign: TextAlign.left,
                                      text: TextSpan(
                                        style: GoogleFonts.ubuntu(
                                          // Use the Google Fonts style
                                          color: const Color(0xFF0D47A1),
                                          fontSize: 25,
                                        ),
                                        children: const [
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
                                        color: const Color(0xFF0D47A1),
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
                                    contentPadding:
                                        const EdgeInsets.only(left: 0, top: 0),
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
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: GestureDetector(
                                      onTap: () {
                                        // Implement the logic for "Forgot Password" here
                                        print('Forgot Password tapped');
                                      },
                                      child: const Align(
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
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        const Color.fromARGB(255, 38, 58, 88),
                                      ),
                                      padding: MaterialStateProperty.all<
                                          EdgeInsetsGeometry>(
                                        const EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 1),
                                      ),
                                      textStyle:
                                          MaterialStateProperty.all<TextStyle>(
                                        const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    child: Text(
                                      'Sign in',
                                      style: GoogleFonts.ubuntu(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        fontSize: 20,
                                        letterSpacing: 3.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),

                                  const SizedBox(height: 20),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          color: Colors.black,
                                          height: 36,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: _signInWithGoogle,
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  const Color.fromARGB(
                                                      255, 255, 7, 7)),
                                        ),
                                        icon: const Icon(
                                            Icons.g_mobiledata_rounded),
                                        label: const Text('Google'),
                                      ),
                                      const SizedBox(width: 10),
                                      ElevatedButton.icon(
                                        onPressed: _signInWithFacebook,
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.blue),
                                        ),
                                        icon: const Icon(Icons.facebook),
                                        label: const Text('Facebook'),
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
                                    child: const Expanded(
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
                                  ),
                                  const Divider(
                                    color: Colors.black,
                                    height: 36,
                                  ),

                                  const Center(
                                    child: Text(
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            // Navigate to Apple Store
                                            print('Navigate to Apple Store');
                                          },
                                          child: Image.asset(
                                            'assets/images/apple.png',
                                            height: 200,
                                            width: 200,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            // Navigate to Play Store
                                            print('Navigate to Play Store');
                                          },
                                          child: Image.asset(
                                            'assets/images/google.png',
                                            height: 110,
                                            width: 200,
                                          ),
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
                )),
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
        this.error =
            'Login failed: $error'; // Use 'this.error' to refer to the instance variable
      });
      print('Login failed: $error');
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential authResult =
            await FirebaseAuth.instance.signInWithCredential(credential);
        final User? user = authResult.user;

        if (user != null) {
          _redirectToNewPage();
          print('Google Sign-In Successful. User: $user');
        } else {
          print('Google Sign-In Failed.');
        }
      }
    } catch (error) {
      print('Google Sign-In Error: $error');
    }
  }

  Future<void> _signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final AuthCredential credential =
            FacebookAuthProvider.credential(accessToken.token);

        final UserCredential authResult =
            await FirebaseAuth.instance.signInWithCredential(credential);
        final User? user = authResult.user;

        if (user != null) {
          _redirectToNewPage();
          print('Facebook Login Successful. User: $user');
        } else {
          print('Facebook Login Failed.');
        }
      } else {
        print('Facebook Login Cancelled.');
      }
    } catch (error) {
      print('Facebook Login Error: $error');
    }
  }

  // ...

  // New method to redirect to a new page
  void _redirectToNewPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const MyHomePage(), // Replace YourNewPage with the actual page you want to navigate to.
      ),
    );
  }
}

void _showAgreementDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Terms and Conditions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Text('.............'),
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
            child: const Text('No', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const RegistrationPage()),
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: const Text('Yes', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}
