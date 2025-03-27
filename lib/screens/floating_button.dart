import 'package:flutter/material.dart';
import 'package:food_app_ui/constant/app_color.dart';
import 'package:food_app_ui/screens/cart_screen.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CartScreen()),
        );
      },
      child: Container(
        width: 72,
        height: 72,
        decoration: ShapeDecoration(
          color: const Color.fromARGB(255, 97, 8, 212),
          shape: const OvalBorder(),
          shadows: [
            BoxShadow(
              color: const Color(0x66000000),
              blurRadius: 16,
              offset: const Offset(0, 5),
              spreadRadius: 5,
            )
          ],
        ),
        child: const Icon(
          Icons.shopping_cart,
          size: 35,
          color: AppColor.floatingActionIconColor,
        ),
      ),
    );
  }
}
