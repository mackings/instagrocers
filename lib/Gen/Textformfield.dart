import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class ContainerTextFormField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const ContainerTextFormField({
    Key? key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.prefixIcon,
    this.suffixIcon,
  }) : super(key: key);

  @override
  _ContainerTextFormFieldState createState() => _ContainerTextFormFieldState();
}

class _ContainerTextFormFieldState extends State<ContainerTextFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label Text
        Text(
          widget.label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),

        // Container with TextFormField
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.isPassword ? _obscureText : false,
            style: GoogleFonts.poppins(fontSize: 16),
            decoration: InputDecoration(
              hintText: widget.hintText,
              border: InputBorder.none,
              hintStyle: GoogleFonts.poppins(color: Colors.grey),
              
              // Prefix Icon (optional)
              prefixIcon: widget.prefixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: widget.prefixIcon,
                    )
                  : null,

              // Suffix Icon (optional)
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : (widget.suffixIcon != null
                      ? Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: widget.suffixIcon,
                        )
                      : null),
            ),
          ),
        ),
      ],
    );
  }
}


