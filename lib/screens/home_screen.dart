import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';  // Thêm import FirebaseAuth
import 'package:food_app_ui/screens/food_suggestion_screen.dart';
import 'package:food_app_ui/screens/feedback_view_screen.dart';
import 'package:food_app_ui/screens/customer_support_screen.dart';
import 'package:food_app_ui/screens/caloric_needs_screen.dart';
import '../constant/app_color.dart';
import 'bottom_appbar_menu.dart';
import 'floating_button.dart';
import 'item_details_screen.dart';
import '../constant/theme_provider.dart';
import '../localization/localization_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = "Chicken";
  String _searchKeyword = "";
  final List<String> favoriteItems = [];
  String? userId;  // Thêm biến userId

  @override
  void initState() {
    super.initState();
    _getUserId();
  }

  // Lấy userId từ FirebaseAuth
  Future<void> _getUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid; // Lấy userId của người dùng hiện tại
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text('Trang Chủ'),
        actions: [
          // Thêm icon nút tính nhu cầu calo
          IconButton(
            icon: const Icon(Icons.accessibility_new), // Icon tính nhu cầu calo
            onPressed: () {
              // Kiểm tra xem userId có null không trước khi chuyển hướng
              if (userId != null) {
                // Chuyển hướng đến màn hình tính nhu cầu calo
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CaloricNeedsScreen(userId: userId!),  // Truyền userId vào màn hình CaloricNeedsScreen
                  ),
                );
              } else {
                // Nếu không có userId, hiển thị thông báo
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Vui lòng đăng nhập để sử dụng tính năng này.')),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              _homeHeader(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              _searchSection(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              _categorySlider(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              _itemList(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: const FloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomAppBarMenu(),
    );
  }

  Widget _homeHeader() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pizza 3P',
                    style: TextStyle(
                      color: AppColor.homeTitleColor,
                      fontSize: 40,
                      fontFamily: 'Lobster',
                      fontWeight: FontWeight.w400,
                      height: 1.0,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Vị ngon trên từng ngón tay!',
                    style: TextStyle(
                      color: AppColor.homeHeaderSubtitleTextColor,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Row(
                  children: [
                    // Thêm icon bóng đèn ở đây
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColor.primaryColor, width: 2),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.lightbulb_outline, color: AppColor.homeTitleColor),
                        onPressed: () {
                          // Chuyển hướng đến màn hình gợi ý món ăn khi nhấn vào icon bóng đèn
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FoodSuggestionScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    // Icon hỗ trợ khách hàng
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColor.primaryColor, width: 2),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(Icons.message_outlined, color: AppColor.homeTitleColor),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CustomerSupportScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _searchSection() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Tìm kiếm",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchKeyword = value.toLowerCase();
                });
              },
            ),
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
      ],
    );
  }

  Widget _categorySliderItem(String imagePath, String categoryName) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = categoryName;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          width: 65,
          height: 65,
          decoration: ShapeDecoration(
            color: selectedCategory == categoryName
                ? AppColor.primaryColor
                : Colors.grey.shade300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                imagePath,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _categorySlider() {
    List<Map<String, String>> categories = [
      {"name": "Chicken", "image": "assets/images/1.jpg"},
      {"name": "Burger", "image": "assets/images/2.jpg"},
      {"name": "Drinks", "image": "assets/images/3.jpg"},
      {"name": "Other", "image": "assets/images/4.jpg"},
      {"name": "Pizza", "image": "assets/images/5.jpg"},
    ];

    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Center(
        child: Wrap(
          spacing: 10,
          alignment: WrapAlignment.center,
          children: categories.map((category) {
            return _categorySliderItem(category["image"]!, category["name"]!);
          }).toList(),
        ),
      ),
    );
  }

  Widget _itemList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('foods')
          .where('category', isEqualTo: selectedCategory)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text("Không có món ăn nào trong danh mục này."),
          );
        }

        List<DocumentSnapshot> foodItems = snapshot.data!.docs;

        List<DocumentSnapshot> filteredFoodItems = foodItems.where((food) {
          String name = food['name'].toString().toLowerCase();
          return name.contains(_searchKeyword);
        }).toList();

        if (filteredFoodItems.isEmpty) {
          return const Center(
            child: Text("Không tìm thấy món ăn nào."),
          );
        }

        return Column(
          children: List.generate(filteredFoodItems.length, (index) {
            var food = filteredFoodItems[index];
            bool isFavorite = favoriteItems.contains(food['name']);

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemDetailsScreen(foodId: food.id),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        food['imageUrl'],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            food['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${food['price']} VNĐ",
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColor.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.feedback_outlined),
                      color: AppColor.primaryColor,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FeedbackViewScreen(
                              foodId: food.id,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? AppColor.primaryColor : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          if (isFavorite) {
                            favoriteItems.remove(food['name']);
                          } else {
                            favoriteItems.add(food['name']);
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }


}
