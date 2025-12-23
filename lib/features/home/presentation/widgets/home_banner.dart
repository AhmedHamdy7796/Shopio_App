import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/utils/app_assets.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: const Color(0xFFEDD3C3), // Fallback color from placeholder
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: SvgPicture.asset(AppAssets.bannerSummer, fit: BoxFit.cover),
      ),
    );
  }
}
