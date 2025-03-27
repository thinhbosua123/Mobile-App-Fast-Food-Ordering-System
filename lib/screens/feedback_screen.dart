import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // Import gói flutter_rating_bar
import 'package:food_app_ui/constant/app_color.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController feedbackController = TextEditingController();
  double _currentRating = 3.0; // Lưu số sao đánh giá mặc định

  Stream<QuerySnapshot> _getFoodItems() {
    return FirebaseFirestore.instance.collection('foods').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đánh giá món ăn'),
        backgroundColor: AppColor.primaryColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getFoodItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Hiện chưa có món ăn nào."));
          }

          // Nhóm món ăn theo category
          Map<String, List<DocumentSnapshot>> categorizedFoods = {};
          for (var doc in snapshot.data!.docs) {
            String category = doc['category'] ?? 'Khác'; // Lấy category hoặc mặc định là 'Khác'
            if (!categorizedFoods.containsKey(category)) {
              categorizedFoods[category] = [];
            }
            categorizedFoods[category]!.add(doc);
          }

          return ListView(
            children: categorizedFoods.entries.map((entry) {
              String category = entry.key;
              List<DocumentSnapshot> foods = entry.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hiển thị tiêu đề category
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      category,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Hiển thị danh sách món ăn trong category
                  ...foods.map((food) => _buildFeedbackItem(food)).toList(),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildFeedbackItem(DocumentSnapshot food) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        child: ListTile(
          contentPadding: const EdgeInsets.all(10),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              food['imageUrl'],
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            food['name'],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            "${food['price']} VNĐ",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.feedback,
              color: Colors.blue,
            ),
            onPressed: () {
              _showFeedbackDialog(food.id);
            },
          ),
        ),
      ),
    );
  }

  void _showFeedbackDialog(String foodId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Để lại Đánh Giá'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: feedbackController,
                    decoration:
                    const InputDecoration(hintText: "Nhập phản hồi của bạn"),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 10),
                  RatingBar.builder(
                    initialRating: _currentRating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _currentRating = rating;
                      });
                    },
                  ),
                  Text(
                    "Bạn đánh giá: $_currentRating sao",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Hủy'),
                ),
                TextButton(
                  onPressed: () {
                    _submitFeedback(foodId, feedbackController.text);
                    feedbackController.clear();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Gửi'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _submitFeedback(String foodId, String feedback) async {
    final userId = _auth.currentUser?.uid ?? 'Người dùng ẩn danh';
    final feedbackCollection = FirebaseFirestore.instance
        .collection('foods')
        .doc(foodId)
        .collection('feedback');

    try {
      await feedbackCollection.add({
        'userId': userId,
        'feedback': feedback,
        'rating': _currentRating, // Thêm rating
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đánh giá đã được gửi')),
      );

      print(
          'Đánh giá đã được gửi cho món: $foodId với nội dung: $feedback, rating: $_currentRating sao');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã xảy ra lỗi khi gửi đánh giá')),
      );

      print('Lỗi khi gửi đánh giá: $e');
    }
  }

}
