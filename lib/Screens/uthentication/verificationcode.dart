import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_final_project/Models/Authentication/verify_otp/verify_otp_response_model.dart';
import 'package:flutter_final_project/Screens/uthentication/createnewpassword.dart';
import 'package:flutter_final_project/networks/api_services.dart';
import 'package:flutter_final_project/networks/network_client.dart';
import 'package:pinput/pinput.dart';

class Verification extends StatefulWidget {
  final String email;

  const Verification({super.key, required this.email});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();
  final ApiServices _api = ApiServices(NetworkClient());
  bool _isLoading = false;

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Title
              const Text(
                "Enter Verification Code",
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
              const SizedBox(height: 36),

              Pinput(
                controller: _pinController,
                focusNode: _pinFocusNode,
                length: 6,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                defaultPinTheme: _pinTheme(
                  fillColor: Colors.grey.shade50,
                  borderColor: Colors.grey.shade300,
                ),
                focusedPinTheme: _pinTheme(
                  fillColor: const Color(0xFFE8F5E9),
                  borderColor: const Color(0xFF138048),
                  borderWidth: 1.5,
                ),
                submittedPinTheme: _pinTheme(
                  fillColor: const Color(0xFFE8F5E9),
                  borderColor: const Color(0xFF138048),
                ),
              ),
              const SizedBox(height: 36),

              // Resend Code & Countdown Timer Text
              Center(
                child: Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        children: [
                          const TextSpan(text: "You can resend the code in "),
                          TextSpan(
                            // text: "$_secondsRemaining",
                            style: const TextStyle(
                              color: Color(0xFF138048),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(text: " seconds"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // GestureDetector(
                    //   // _secondsRemaining == 0 ? _startTimer : null,
                    //   onTap: () {},
                    //   child: Text(
                    //     "Resend Code",
                    //     style: TextStyle(
                    //       color: _secondsRemaining == 0
                    //           ? const Color(0xFF138048)
                    //           : const Color(0xFF138048).withOpacity(0.6),
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 14,
                    //     ),
                    //   ),
                    // ),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _verifyOtp,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text("Create password"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _verifyOtp() async {
    final otp = _pinController.text;
    if (otp.length != 6) {
      _showMessage("Please enter the 6-digit verification code");
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await _api.verifyForgotPasswordOtp({
        "email": widget.email,
        "code": otp,
      });

      final result = VerifyOtpResponse.fromJson(
        response.data as Map<String, dynamic>,
      );

      if (!mounted) return;
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CreateNewPassword(verifyOtp: result),
          ),
        );
      } else {
        _showMessage(
          response.data is Map && response.data["message"] != null
              ? response.data["message"].toString()
              : "Invalid verification code",
        );
      }
    } catch (_) {
      if (mounted) _showMessage("Unable to verify the code");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  PinTheme _pinTheme({
    required Color fillColor,
    required Color borderColor,
    double borderWidth = 1,
  }) {
    return PinTheme(
      width: 44,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: borderWidth),
      ),
    );
  }
}
