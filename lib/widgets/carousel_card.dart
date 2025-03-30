import 'package:flutter/material.dart';
import '../constants/restaurants.dart';

Widget carouselCard(int index, double distance, double duration) {
  return Card(
    clipBehavior: Clip.antiAlias,
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(restaurants[index]['image'] as String),
            radius: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurants[index]['name'] as String,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(restaurants[index]['items'] as String,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 5),
                Text(
                  '${distance.toStringAsFixed(2)}kms, ${duration.toStringAsFixed(2)} mins',
                  style: const TextStyle(color: Colors.teal),
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}