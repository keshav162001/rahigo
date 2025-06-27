import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'welcome_screen.dart';
import 'signup_screen.dart';
import 'admin_home_screen.dart'; // ✅ Import Admin Screen

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;
  bool _isLoading = false;

  bool isAdminMode = false;
  int _adminTapCount = 0;
  Timer? _tapTimer;

  static const String adminUID = "2oyGtMAdWNYOqfyk0UTQ0mBTMcv1";

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        final uid = userCredential.user?.uid;

        if (isAdminMode && uid != adminUID) {
          await _auth.signOut();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Access Denied: You are not the Admin."),
              backgroundColor: Colors.redAccent,
            ),
          );
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Login Successful", style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.grey.withOpacity(0.4),
            elevation: 10,
            behavior: SnackBarBehavior.fixed,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            duration: Duration(seconds: 2),
          ),
        );

        // ✅ Navigate to respective screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => isAdminMode ? AdminHomeScreen() : WelcomeScreen(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        String message = "Login failed";
        if (e.code == 'user-not-found') message = "No user found for this email.";
        if (e.code == 'wrong-password') message = "Incorrect password.";
        if (e.code == 'invalid-email') message = "Invalid email format.";

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleAdminTapArea() {
    _adminTapCount++;
    if (_adminTapCount == 3) {
      _tapTimer?.cancel();
      _adminTapCount = 0;
      setState(() {
        isAdminMode = !isAdminMode;
      });
    } else {
      _tapTimer?.cancel();
      _tapTimer = Timer(Duration(seconds: 2), () {
        _adminTapCount = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // 🔹 Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg_monument.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 🔹 Semi-transparent overlay
          Container(color: Colors.black.withOpacity(0.3)),

          // 🔹 Lottie animation at bottom
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Lottie.asset(
              'assets/india_bottom_lottie.json',
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // ✅ Hidden top-right triple-tap admin toggle
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _handleAdminTapArea,
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.transparent,
                ),
              ),
            ),
          ),

          // 🔹 Login Form with Glassmorphism
          Align(
            alignment: Alignment(0, -0.2),
            child: SingleChildScrollView(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    padding: EdgeInsets.all(24),
                    width: width * 0.85,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            isAdminMode ? "Admin Login" : "Welcome Back!",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cinzel',
                            ),
                          ),
                          SizedBox(height: 30),
                          _buildTextField("Email", Icons.email, _emailController, false, isEmail: true),
                          SizedBox(height: 20),
                          _buildTextField("Password", Icons.lock, _passwordController, true),
                          SizedBox(height: 30),
                          _isLoading
                              ? CircularProgressIndicator(color: Colors.orangeAccent)
                              : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent.shade200,
                              foregroundColor: Colors.black,
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _login,
                            child: Text("Login"),
                          ),
                          SizedBox(height: 20),
                          if (!isAdminMode)
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => SignUpScreen()),
                                );
                              },
                              child: RichText(
                                text: TextSpan(
                                  text: "Don't have an account? ",
                                  style: TextStyle(color: Colors.white70),
                                  children: [
                                    TextSpan(
                                      text: "Sign Up",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, IconData icon, TextEditingController controller, bool isPassword,
      {bool isEmail = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? _obscureText : false,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      style: TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return "Please enter $hint";
        if (isEmail && !value.contains('@')) return "Enter a valid email";
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white70),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.white70,
          ),
          onPressed: () => setState(() => _obscureText = !_obscureText),
        )
            : null,
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white60),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white30),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white30),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.orangeAccent),
        ),
      ),
    );
  }
}
