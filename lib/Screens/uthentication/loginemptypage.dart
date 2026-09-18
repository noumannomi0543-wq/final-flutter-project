import 'package:flutter/material.dart';
import 'package:flutter_final_project/Models/Authentication/jwt_response_model.dart';
import 'package:flutter_final_project/Models/Authentication/login_model.dart';
import 'package:flutter_final_project/Screens/Homepage/homev1.dart';
import 'package:flutter_final_project/Screens/uthentication/forgotpassword.dart';
import 'package:flutter_final_project/Screens/uthentication/register.dart';
import 'package:flutter_final_project/networks/api_services.dart';
import 'package:flutter_final_project/networks/network_client.dart';

class Loginemptypage extends StatefulWidget {
  const Loginemptypage({super.key});

  @override
  State<Loginemptypage> createState() => _LoginemptypageState();
}

class _LoginemptypageState extends State<Loginemptypage> {
  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // State variable to toggle password visibility
  bool _isObscured = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  final api = ApiServices(NetworkClient());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Title
              const Text(
                "Welcome Back!",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle
              Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),

              // Email Label
              const Text(
                "Email",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),

              // Email Input Box
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _buildInputDecoration(hintText: "Enter your email"),
              ),
              const SizedBox(height: 20),

              // Password Label
              const Text(
                "Password",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),

              // Password Input Box
              TextField(
                controller: _passwordController,
                obscureText: _isObscured,
                decoration: _buildInputDecoration(
                  hintText: "Enter your password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscured
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.grey.shade500,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Forgot Password Link
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return Forgotpassword();
                        },
                      ),
                    );
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Sign In Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    final loginRequest = Login(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                    debugPrint("Email: ${loginRequest.email}");
                    debugPrint("Password: ${loginRequest.password}");
                    final response = await api.login(loginRequest.toJson());
                    if (!context.mounted) return;

                    if (response.statusCode == 200) {
                      debugPrint("Login successful: ${response.data}");
                      final result = JwtResponse.fromJson(
                        response.data as Map<String, dynamic>,
                      );
                      debugPrint("Token: ${result.token}");

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Homev1();
                          },
                        ),
                      );
                    } else {
                      debugPrint(
                        "Login failed: ${response.statusCode} - ${response.data}",
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Sign In",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Divider
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Or continue with",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),
              const SizedBox(height: 24),

              // Social Media Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,

                    child: Image.asset("assets/images/google.png"),
                  ),
                  const SizedBox(width: 16),
                  _buildSocialButton(
                    child: const Icon(
                      Icons.apple,
                      color: Colors.black,
                      size: 24,
                    ),
                    onTap: () {},
                  ),
                  const SizedBox(width: 16),
                  _buildSocialButton(
                    child: const Icon(
                      Icons.facebook,
                      color: Colors.blue,
                      size: 24,
                    ),
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Sign Up Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don’t have an account? ",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Register();
                          },
                        ),
                      );
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for TextField Decoration (Focus styling added here)
  InputDecoration _buildInputDecoration({
    required String hintText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey.shade400),
      filled: true,
      fillColor: const Color(0xFFE8F5E9),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xFF4CAF50), // Green border color
          width: 1.5,
        ),
      ),
      suffixIcon: suffixIcon,
    );
  }

  // Social Button Helper
  Widget _buildSocialButton({
    required Widget child,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 60,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
