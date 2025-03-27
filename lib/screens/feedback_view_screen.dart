import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // Import cho RatingBar

class FeedbackViewScreen extends StatelessWidget {
  final String foodId;

  const FeedbackViewScreen({Key? key, required this.foodId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phản Hồi Của Người Dùng'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('foods')
            .doc(foodId)
            .collection('feedback')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Không có phản hồi nào."));
          }

          var feedbackList = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: feedbackList.length,
            itemBuilder: (context, index) {
              var feedback = feedbackList[index];

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hiển thị tên người dùng
                      Text(
                        feedback['userId'] ?? 'Người dùng không xác định',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      // Hiển thị nội dung phản hồi
                      Text(
                        feedback['feedback'] ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      // Hiển thị đánh giá sao
                      if (feedback['rating'] != null)
                        Row(
                          children: [
                            RatingBarIndicator(
                              rating: feedback['rating']?.toDouble() ?? 0.0,
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 20.0,
                              direction: Axis.horizontal,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              "${feedback['rating']} sao",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 8.0),
                      // Hiển thị thời gian phản hồi
                      Text(
                        feedback['timestamp'] != null
                            ? (feedback['timestamp'] as Timestamp)
                            .toDate()
                            .toLocal()
                            .toString()
                            : '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
