import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class CustomButton extends StatelessWidget {
  final String? text;
  final Color color;
  final VoidCallback? onPressed;
  final bool isBorderBtn;
  final Color? borderColor;
  final Widget? child; 

  const CustomButton({
    Key? key,
    this.text, // Make text optional
    required this.color,
    this.onPressed,
    this.isBorderBtn = false,
    this.borderColor,
    this.child, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        decoration: BoxDecoration(
          color: isBorderBtn ? Colors.white : color,
          borderRadius: BorderRadius.circular(12),
          border: isBorderBtn ? Border.all(color: borderColor ?? Colors.black, width: 2) : null,
        ),
        child: Center(
          child: child ??
              Text(
                text ?? "", // Show text if child is null
                style: GoogleFonts.poppins(
                  color: isBorderBtn ? borderColor ?? Colors.black : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
        ),
      ),
    );
  }
}

