import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

// Recommended File Path: lib/screens/phone_auth_screen.dart

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  
  String? _verificationId;
  bool _isOtpSent = false;
  bool _isLoading = false; // To show a loading indicator

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  // --- FIREBASE INTEGRATION: STEP 1 (NOW FULLY FUNCTIONAL) ---
  Future<void> _sendOtp() async {
    final phoneNumber = '+237${_phoneController.text.trim()}';
    if (_phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number.')),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // This is for auto-retrieval on Android devices.
          await FirebaseAuth.instance.signInWithCredential(credential);
          setState(() {
            _isLoading = false;
          });
          // Navigate to home page on success
          // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => HomePage()));
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            _isLoading = false;
          });
          print('Verification Failed: ${e.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification Failed: ${e.message}')),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          // This is called when the SMS is sent.
          setState(() {
            _verificationId = verificationId; // <-- CORRECT: Save the REAL verificationId
            _isOtpSent = true;
            _isLoading = false;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Called when auto-retrieval has timed out.
          setState(() {
            _verificationId = verificationId;
          });
        },
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Failed to send OTP: $e");
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send OTP: $e')),
      );
    }
  }

  // --- FIREBASE INTEGRATION: STEP 2 (NOW FULLY FUNCTIONAL) ---
  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();
    if (otp.length < 6 || _verificationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit code.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create the credential with the verification ID and the OTP code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );
      
      // Sign the user in with the credential
      await FirebaseAuth.instance.signInWithCredential(credential);

      setState(() {
        _isLoading = false;
      });
      
      // Navigate to home screen on success
      // Replace 'HomePage()' with your actual home page widget
      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => HomePage()));
      print("Phone number verified successfully!");
      Navigator.of(context).pop(); // For now, just pop back

    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('OTP Verification Failed: ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP Verification Failed: ${e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A2F4B)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              _isOtpSent ? 'Enter Verification Code' : 'Enter Your Phone Number',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A2F4B),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _isOtpSent
                  ? 'We have sent a 6-digit code to\n+237 ${_phoneController.text}'
                  : 'We will send you a 6-digit verification code.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 60),
            
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _isOtpSent ? _buildOtpInput() : _buildPhoneInput(),
            ),

            const SizedBox(height: 40),
            
            // Show loading indicator or button
            if (_isLoading)
              const Center(child: CircularProgressIndicator(color: Color(0xFF1A2F4B)))
            else
              ElevatedButton(
                onPressed: _isOtpSent ? _verifyOtp : _sendOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A2F4B),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  shadowColor: const Color(0xFF1A2F4B).withOpacity(0.4),
                ),
                child: Text(
                  _isOtpSent ? 'Verify Code' : 'Send Code',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            if (_isOtpSent && !_isLoading)
              TextButton(
                onPressed: () => setState(() {
                  _isOtpSent = false;
                  _verificationId = null;
                }), 
                child: Text(
                  'Enter a different phone number', 
                  style: GoogleFonts.poppins(color: const Color(0xFF1A2F4B))
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneInput() {
    return Column(
      key: const ValueKey('phone-input'),
      children: [
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          style: GoogleFonts.poppins(color: Colors.black87, fontSize: 18),
          decoration: InputDecoration(
            hintText: '699 99 99 99',
            hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
            filled: true,
            fillColor: Colors.grey[100],
            prefixIcon: Padding(
              padding: const EdgeInsets.fromLTRB(12, 14, 10, 14),
              child: Text(
                '+237',
                style: GoogleFonts.poppins(
                  fontSize: 18, 
                  color: Colors.black87,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1A2F4B), width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpInput() {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: GoogleFonts.poppins(fontSize: 22, color: const Color(0xFF1A2F4B)),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.transparent),
      ),
    );
    
    return Pinput(
      key: const ValueKey('otp-input'),
      length: 6,
      controller: _otpController,
      autofocus: true,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          border: Border.all(color: const Color(0xFF1A2F4B), width: 2),
        ),
      ),
      onCompleted: (pin) => _verifyOtp(),
    );
  }
}
