import 'package:flutter/material.dart';

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({super.key, required this.text, required this.onTap});
  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: w,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.teal.shade500,
          borderRadius: BorderRadius.circular(30),

        ),
        child: Center(child: Text(text,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600
          ),)),
      ),
    );
  }
}
