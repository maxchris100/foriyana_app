import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foriyana_app/core/router/app_router.dart';
import 'package:foriyana_app/presentation/blocs/cubit/home_cubit.dart';

class AppDrawer extends StatelessWidget {
  final String selectedMenu;

  const AppDrawer({super.key, required this.selectedMenu});

  @override
  Widget build(BuildContext context) {
    HomeCubit homeCubit = context.watch<HomeCubit>();

    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(30)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Row(
                children: [
                  CircleAvatar(
                      radius: 30,
                      child: SvgPicture.asset(
                        "assets/icons/default-avatar.svg",
                        height: 40,
                        width: 40,
                      )),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Sunie Pham",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text("sunieux@gmail.com"),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(),

            // Menu Items
            _buildMenuItem(context, "assets/icons/home_home.svg", "Homepage",
                onTap: () {
              homeCubit.changeTab(0, menu: "Homepage");
              Navigator.pop(context);
            }),
            _buildMenuItem(context, "assets/icons/home_search.svg", "Discover",
                onTap: () {
              homeCubit.changeTab(1, menu: "Discover");
              Navigator.pop(context);
            }),
            _buildMenuItem(context, "assets/icons/home_cart.svg", "My Order",
                onTap: () {
              homeCubit.changeTab(2, menu: "My Order");
              Navigator.pop(context);
            }),
            _buildMenuItem(
                context, "assets/icons/home_profile.svg", "My Profile",
                onTap: () {
              homeCubit.changeTab(3, menu: "My Profile");
              Navigator.pop(context);
            }),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text("OTHER",
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
            ),

            _buildMenuItem(context, "assets/icons/setting.svg", "Setting",
                onTap: () {
              Navigator.pushNamed(context, AppRouter.settings);
            }),
            _buildMenuItem(context, "assets/icons/support.svg", "Support",
                onTap: () {
              Navigator.pushNamed(context, AppRouter.support);
            }),
            _buildMenuItem(context, "assets/icons/info.svg", "About us",
                onTap: () {
              Navigator.pushNamed(context, AppRouter.about);
            }),

            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String icon, String label,
      {Function()? onTap}) {
    final isSelected = label == selectedMenu;

    return ListTile(
        leading: SvgPicture.asset(icon,
            color: isSelected ? Colors.black : Colors.grey),
        title: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.black : Colors.grey,
          ),
        ),
        tileColor: isSelected ? Colors.grey.shade200 : Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: onTap);
  }
}
