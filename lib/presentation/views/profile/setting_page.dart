import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foriyana_app/core/router/app_router.dart';
import 'package:foriyana_app/presentation/widgets/app_drawer.dart';
import 'package:foriyana_app/presentation/widgets/button_back.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: ButtonBack(),
        leadingWidth: 40,
      ),
      drawer: const AppDrawer(selectedMenu: "Setting"),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          SettingItem(
            icon: SvgPicture.asset("assets/icons/globe.svg"),
            title: 'Language',
          ),
          SettingItem(
            icon: SvgPicture.asset("assets/icons/notification.svg"),
            title: 'Notification',
            onTap: () {
              Navigator.pushNamed(context, AppRouter.notification);
            },
          ),
          SettingItem(
            icon: SvgPicture.asset("assets/icons/tnc.svg"),
            title: 'Terms of Use',
          ),
          SettingItem(
            icon: SvgPicture.asset("assets/icons/info.svg"),
            title: 'Privacy Policy',
          ),
          SettingItem(
            icon: SvgPicture.asset("assets/icons/support.svg"),
            title: 'Chat support',
            onTap: () {
              Navigator.pushNamed(context, AppRouter.support);
            },
          ),
        ],
      ),
    );
  }
}

class SettingItem extends StatelessWidget {
  final Widget icon;
  final String title;
  final VoidCallback? onTap;

  const SettingItem(
      {super.key, required this.icon, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
            leading: icon,
            title: Text(title),
            trailing: const Icon(Icons.chevron_right),
            onTap: onTap),
        const Divider(height: 1, thickness: 0.4),
      ],
    );
  }
}
