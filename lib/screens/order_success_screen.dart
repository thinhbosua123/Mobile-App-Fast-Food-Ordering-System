import 'package:flutter/material.dart';
import 'package:food_app_ui/screens/cart_provider.dart';
import 'package:provider/provider.dart';
import '../constant/app_color.dart';
import 'home_screen.dart';



class OrderSuccessScreen extends StatelessWidget {
  final List<String> orderedProductIds;
  final List<int> orderedQuantities;

  const OrderSuccessScreen({
    Key? key,
    required this.orderedProductIds,
    required this.orderedQuantities,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cartProvider.clearCart();
    });

    return Scaffold(
      backgroundColor: AppColor.orderSuccessScreenBackgroundColor,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: AppColor.orderSuccessScreenContainerBackgroundColor,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade600,
                spreadRadius: 1,
                blurRadius: 15,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Icon(
                  Icons.check_circle,
                  color: AppColor.primaryColor,
                  size: 70.0,
                ),
              ),
              Text(
                "Success !",
                style: TextStyle(
                  color: AppColor.primaryColor,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  fontFamily: "Poppins",
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Text(
                "Thanh toán thành công.\n Vui lòng để ý số điện thoại \nCảm ơn bạn đã đặt đồ ăn!.",
                style: TextStyle(
                  color: Color(0xff808080),
                  fontSize: 14,
                  fontFamily: "Poppins",
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.07),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return HomeScreen();
                  }));
                },
                child: Container(
                  height: 62,
                  width: MediaQuery.of(context).size.width * 0.530,
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Center(
                    child: Text(
                      "Go back",
                      style: TextStyle(
                        color: AppColor.priceButtonTextColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
