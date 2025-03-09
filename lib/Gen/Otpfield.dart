import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class OtpVerificationWidget extends StatefulWidget {
  final String phoneNumber;
  final VoidCallback onResend;
  final VoidCallback onChangeNumber;
  final VoidCallback onVerify;

  const OtpVerificationWidget({
    Key? key,
    required this.phoneNumber,
    required this.onResend,
    required this.onChangeNumber,
    required this.onVerify,
    required TextEditingController otpController,
  }) : super(key: key);

  @override
  State<OtpVerificationWidget> createState() => _OtpVerificationWidgetState();
}

class _OtpVerificationWidgetState extends State<OtpVerificationWidget> {

  late Timer _timer;
  int _secondsRemaining = 224; // 3 min 44 sec
  final List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    _startTimer();  
  }



  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();

  }



  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer.cancel();
      }
    });
  }


  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$remainingSeconds";
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Text(
          "Otp Verification",
          style: GoogleFonts.firaSans(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Enter the 4-digit code sent to your phone number: ${widget.phoneNumber}",
          textAlign: TextAlign.center,
          style: GoogleFonts.firaSans(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 24),

        // OTP Input Fields
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            4,
            (index) => Container(
              width: 50,
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: TextField(
                controller: _otpControllers[index],
                focusNode: _focusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                style: GoogleFonts.firaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                onChanged: (value) => _onOtpChanged(value, index),
                decoration: const InputDecoration(
                  counterText: "", // Hide character counter
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Countdown Timer
        Text(
          _formatTime(_secondsRemaining),
          style: GoogleFonts.firaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),

        // Resend OTP
        TextButton(
          onPressed: widget.onResend,
          child: Text(
            "Resend SMS",
            style: GoogleFonts.firaSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),

        // Change Number
        TextButton(
          onPressed: widget.onChangeNumber,
          child: Text(
            "Change number",
            style: GoogleFonts.firaSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),

        const Spacer(),

        // Verify Button at Bottom
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: ElevatedButton(
            onPressed: widget.onVerify,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[400],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: Text(
              "Verify number",
              style: GoogleFonts.firaSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
