import 'package:flutter/material.dart';
import 'package:food_app_ui/constant/app_color.dart';
import 'package:food_app_ui/screens/home_screen.dart';
import 'order_history_screen.dart';
import 'user_profile_screen.dart';
import 'feedback_screen.dart';

class BottomAppBarMenu extends StatefulWidget {
  const BottomAppBarMenu({super.key});

  @override
  State<BottomAppBarMenu> createState() => _BottomAppBarMenuState();
}

class _BottomAppBarMenuState extends State<BottomAppBarMenu> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: MediaQuery.of(context).size.height * 0.08,
      color: AppColor.primaryColor,
      shape: const CircularNotchedRectangle(),
      notchMargin: 5,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.home_outlined,
              color: AppColor.bottomAppbarIconColor,
            ),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return const HomeScreen();
                },
              ));
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.receipt_long,
              color: AppColor.bottomAppbarIconColor,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const OrderHistoryScreen();
                },
              ));
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.star,
              color: AppColor.bottomAppbarIconColor,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const FeedbackScreen();
                },
              ));
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.person_3_outlined,
              color: AppColor.bottomAppbarIconColor,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const UserProfileScreen();
                },
              ));
            },
          ),
        ],
      ),
    );
  }
}
