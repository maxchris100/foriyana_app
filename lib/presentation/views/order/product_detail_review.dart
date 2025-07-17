// ReviewBar Widget
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReviewSectionWidget extends StatelessWidget {
  const ReviewSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Score
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '4.9',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text('OUT OF 5'),
              ],
            ),
            const SizedBox(width: 16),
            // Stars & rating count
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(5, (index) {
                    return const Icon(Icons.star, color: Colors.teal, size: 20);
                  }),
                ),
                const SizedBox(height: 4),
                const Text('83 ratings'),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Progress Bar
        const ReviewBar(rating: 5, percent: 0.80),
        const ReviewBar(rating: 4, percent: 0.12),
        const ReviewBar(rating: 3, percent: 0.05),
        const ReviewBar(rating: 2, percent: 0.03),
        const ReviewBar(rating: 1, percent: 0.00),

        const SizedBox(height: 16),
        const Divider(),

        // Write Review
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('47 Reviews'),
            Row(
              children: [
                Text('WRITE A REVIEW', style: TextStyle(color: Colors.grey)),
                SizedBox(width: 4),
                SvgPicture.asset("assets/icons/edit.svg")
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),

        // User Reviews
        const UserReview(
          name: "Jennifer Rose",
          timeAgo: "5m ago",
          comment:
              "I love it.  Awesome customer service!! Helped me out with adding an additional item to my order. Thanks again!",
          imageUrl: "https://i.pravatar.cc/150?img=47",
        ),
        const SizedBox(height: 16),
        const UserReview(
          name: "Kelly Rihana",
          timeAgo: "9m ago",
          comment:
              "I'm very happy with order, It was delivered on and good quality. Recommended!",
          imageUrl: "https://i.pravatar.cc/150?img=32",
        ),
      ],
    );
  }
}

class ReviewBar extends StatelessWidget {
  final int rating;
  final double percent;

  const ReviewBar({
    super.key,
    required this.rating,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.star, size: 14, color: Colors.teal),
          const SizedBox(width: 4),
          Text('$rating'),
          const SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.teal),
              minHeight: 6,
            ),
          ),
          const SizedBox(width: 8),
          Text('${(percent * 100).round()}%'),
        ],
      ),
    );
  }
}

// UserReview Widget
class UserReview extends StatelessWidget {
  final String name;
  final String timeAgo;
  final String comment;
  final String imageUrl;

  const UserReview({
    super.key,
    required this.name,
    required this.timeAgo,
    required this.comment,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(backgroundImage: NetworkImage(imageUrl), radius: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(timeAgo, style: const TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: List.generate(5, (index) {
                  return const Icon(Icons.star, color: Colors.teal, size: 16);
                }),
              ),
              const SizedBox(height: 4),
              Text(comment),
            ],
          ),
        ),
      ],
    );
  }
}
