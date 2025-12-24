import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/routes/app_routes.dart';
import '../core/theme/cubit/theme_cubit.dart';
import '../features/auth/presentation/cubit/auth_cubit.dart';
import '../core/utils/app_assets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileView();
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            color: Theme.of(context).iconTheme.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.settings,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            // Avatar
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60.r,
                    backgroundColor: Theme.of(context).cardColor,
                    backgroundImage: const AssetImage(
                      'assets/images/avatar_placeholder.png',
                    ),
                    child: SvgPicture.asset(
                      AppAssets.avatarPlaceholder,
                      height: 80.h,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0D6EFD),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().scale(),
            SizedBox(height: 16.h),
            Text(
              'Alex Jordan',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ).animate().fadeIn(),
            Text(
              'alex.jordan@example.com',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
            ).animate().fadeIn(),
            SizedBox(height: 32.h),

            // Stats
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(context, 'Orders', '12'),
                  _buildVerticalDivider(),
                  _buildStatItem(context, 'Wishlist', '5'),
                  _buildVerticalDivider(),
                  _buildStatItem(context, 'Listings', '2'),
                ],
              ),
            ).animate().slideY(begin: 0.2, end: 0),
            SizedBox(height: 32.h),

            // Settings
            _buildSectionTitle(context, 'Settings'),
            SizedBox(height: 16.h),
            _buildSettingsTile(
              context: context,
              icon: Icons.favorite_border,
              title: 'Favorites',
              onTap: () {
                Navigator.pushNamed(context, Routes.favorites);
              },
            ),
            _buildSettingsTile(
              context: context,
              icon: Icons.dark_mode_outlined,
              title: 'Dark Mode',
              trailing: BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, state) {
                  return Switch(
                    value: state == ThemeMode.dark,
                    onChanged: (value) {
                      context.read<ThemeCubit>().toggleTheme(value);
                    },
                    activeTrackColor: const Color(0xFF0D6EFD),
                  );
                },
              ),
            ),
            _buildSettingsTile(
              context: context,
              icon: Icons.lock_outline,
              title: 'Change Password',
              onTap: () {
                Navigator.pushNamed(context, Routes.forgotPassword);
              },
            ),
            _buildSettingsTile(
              context: context,
              icon: Icons.notifications_none,
              title: 'Notifications',
              onTap: () {},
            ),

            SizedBox(height: 32.h),
            _buildSectionTitle(context, 'Support'),
            SizedBox(height: 16.h),
            _buildSettingsTile(
              context: context,
              icon: Icons.help_outline,
              title: 'Help Center',
              onTap: () {},
            ),
            _buildSettingsTile(
              context: context,
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              onTap: () {},
            ),

            SizedBox(height: 32.h),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  context.read<AuthCubit>().logout();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.login,
                    (route) => false,
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Sign Out',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0D6EFD),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(height: 40.h, width: 1, color: Colors.grey.shade200);
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSettingsTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.withValues(alpha: 0.1)
                : const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: Theme.of(context).iconTheme.color),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
        ),
        trailing:
            trailing ??
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    ).animate().fadeIn();
  }
}
