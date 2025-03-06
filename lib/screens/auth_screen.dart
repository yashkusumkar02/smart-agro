import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/auth_service.dart';
import 'forgot_password_screen.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLogin = true;
  bool _isPasswordVisible = false;

  void authenticate() async {
    if (_formKey.currentState!.validate()) {
      final authService = AuthService();
      bool success = isLogin
          ? await authService.signInWithEmail(emailController.text, passwordController.text)
          : await authService.signUpWithEmail(emailController.text, passwordController.text);

      if (success) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Authentication failed. Please check your credentials.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade900, Colors.green.shade500],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 10,
                shadowColor: Colors.black45,
                child: Padding(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isLogin ? "Welcome Back!" : "Create Your Account",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green.shade900),
                      ),
                      SizedBox(height: 20),
                      _buildTextField(emailController, "Email", Icons.email, isEmail: true),
                      SizedBox(height: 10),
                      _buildTextField(passwordController, "Password", Icons.lock, isPassword: true),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: authenticate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(isLogin ? 'Login' : 'Sign Up', style: TextStyle(fontSize: 16)),
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () => setState(() => isLogin = !isLogin),
                        child: Text(
                          isLogin ? "Create an Account" : "Already have an account? Login",
                          style: TextStyle(color: Colors.green.shade800),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordScreen())),
                        child: Text("Forgot Password?", style: TextStyle(color: Colors.red.shade600)),
                      ),
                      SizedBox(height: 15),
                      Divider(thickness: 1, color: Colors.grey.shade400),
                      SizedBox(height: 15),
                      _buildGoogleSignInButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hint, IconData icon,
      {bool isPassword = false, bool isEmail = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? !_isPasswordVisible : false,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) return "This field cannot be empty";
        if (isEmail && !RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
          return "Enter a valid email";
        }
        if (isPassword && value.length < 6) return "Password must be at least 6 characters";
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.green.shade800),
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade100,
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey.shade600),
          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
        )
            : null,
      ),
    );
  }

  Widget _buildGoogleSignInButton() {
    return OutlinedButton.icon(
      onPressed: () {
        // Implement Google Sign-In functionality
      },
      icon: Icon(FontAwesomeIcons.google, color: Colors.red), // Using Google Icon from FontAwesome
      label: Text("Sign in with Google"),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.green.shade800),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
      ),
    );
  }
}
