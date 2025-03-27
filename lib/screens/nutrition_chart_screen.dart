import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class NutritionChart extends StatelessWidget {
  final Map<String, dynamic> foodData;

  NutritionChart({required this.foodData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(foodData['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                foodData['imageUrl'],
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Tên món: ${foodData['name']}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Loại: ${foodData['category']}'),
            Text('Calo: ${foodData['calories']} kcal'),
            const SizedBox(height: 16),
            const Text(
              'Thành phần dinh dưỡng:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: foodData['protein'],
                      title: 'Protein',
                      color: Colors.blue,
                      radius: 50,
                    ),
                    PieChartSectionData(
                      value: foodData['carbs'],
                      title: 'Carbs',
                      color: Colors.yellow,
                      radius: 50,
                    ),
                    PieChartSectionData(
                      value: foodData['fat'],
                      title: 'Fat',
                      color: Colors.red,
                      radius: 50,
                    ),
                  ],
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Quay lại'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Thêm logic cho hành động khác nếu cần
                  },
                  child: const Text('Kiểm tra lượng calo'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
