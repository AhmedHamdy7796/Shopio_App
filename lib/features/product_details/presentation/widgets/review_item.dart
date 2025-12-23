import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewItem extends StatelessWidget {
  final String review;
  final String userName;

  const ReviewItem({super.key, required this.review, this.userName = 'User'});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16.r,
                backgroundColor: Colors.grey.shade300,
                child: Icon(
                  Icons.person,
                  size: 20.r,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                userName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              const Icon(Icons.star, size: 16, color: Colors.amber),
              const Text(' 4.5', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 8.h),
          Text(review),
        ],
      ),
    );
  }
}
