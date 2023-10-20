import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SmallButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed; // Callback to handle selection

  SmallButton({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: isSelected
            ? MaterialStateProperty.all(const Color(0xFF405897)) // Selected color
            : MaterialStateProperty.all(const Color(0xFFD9D9D9)), // Deselected color
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF313131),
          fontSize: 9.sp,
          fontFamily: 'Urbanist',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
