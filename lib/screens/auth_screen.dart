import 'package:estate/screens/pages/home.dart';
import 'package:estate/widgets/auth_form.dart';
import 'package:estate/widgets/auth_header.dart';
import 'package:estate/widgets/social_login_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance; // Firebase Auth instance
  bool _isLogin = true;
  bool _isLoading = false; // To manage loading state

  void _toggleFormType() {
    if (_isLoading) return; // Prevent toggling while loading
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  // --- FIREBASE INTEGRATION ---
  void _submitAuthForm({
    required String email,
    required String password,
    String? fullName,
    required bool isLogin,
  }) async {
    UserCredential userCredential;

    setState(() {
      _isLoading = true;
    });

    try {
      if (isLogin) {
        // --- Sign In Logic ---
        userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        print('User signed in: ${userCredential.user?.uid}');
      } else {
        // --- Sign Up Logic ---
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // After creating the user, update their profile with the full name
        if (userCredential.user != null && fullName != null) {
          await userCredential.user!.updateDisplayName(fullName);
          print('User signed up and profile updated: ${userCredential.user?.uid}');
        }
      }
      
      // On success, navigate to the home screen.
      if (mounted) { // Check if the widget is still in the widget tree
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => const HomeScreen()));
      }

    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase errors
      String message = 'An error occurred, please check your credentials!';
      if (e.message != null) {
        message = e.message!;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } catch (e) {
      // Handle other errors
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('An unexpected error occurred.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      // Ensure loading indicator is turned off
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AuthHeader(),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _isLogin ? 'Welcome Back' : 'Create Account',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A2F4B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isLogin ? 'Sign in to continue' : 'Join us to find your dream home',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Show loading indicator or the form
                  if (_isLoading)
                    const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF1A2F4B),
                      ),
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AuthForm(
                          isLogin: _isLogin,
                          onSubmit: _submitAuthForm,
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: _toggleFormType,
                          child: Text(
                            _isLogin
                                ? 'Don\'t have an account? Sign Up'
                                : 'Already have an account? Sign In',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF1A2F4B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SocialLoginSection(),
                      ],
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
