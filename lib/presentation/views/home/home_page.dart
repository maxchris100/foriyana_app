import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foriyana_app/core/router/app_router.dart';
import 'package:foriyana_app/presentation/blocs/cubit/home_cubit.dart';
import 'package:foriyana_app/presentation/views/home/cart_tab.dart';
import 'package:foriyana_app/presentation/views/home/home_tab.dart';
import 'package:foriyana_app/presentation/views/home/profile_tab.dart';
import 'package:foriyana_app/presentation/views/home/search_tab.dart';
import 'package:foriyana_app/presentation/widgets/app_drawer.dart';
import 'package:foriyana_app/presentation/widgets/filter_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _pages = [
    const HomeTab(),
    const SearchTab(),
    const CartTab(),
    const ProfileTab(),
  ];

  void _onItemTapped(int index) {
    homeCubit.changeTab(index,
        menu: index == 0
            ? "HomePage"
            : index == 1
                ? "Discover"
                : index == 2
                    ? "My Order"
                    : "My Profile");
  }

  HomeCubit homeCubit = HomeCubit();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<HomeCubit>(
            create: (context) => homeCubit,
          ),
        ],
        child: BlocBuilder<HomeCubit, HomeState>(builder: (context2, state) {
          return Scaffold(
            appBar: AppBar(
              scrolledUnderElevation: 0,
              title: const Text("M-Mart",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              centerTitle: true,
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: SvgPicture.asset("assets/icons/menu.svg"),
                    onPressed: () {
                      Scaffold.of(context)
                          .openDrawer(); // context di sini sudah benar
                    },
                  );
                },
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRouter.cart);
                    },
                    child: SvgPicture.asset(
                      "assets/icons/shopping_bag.svg",
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRouter.notification);
                      },
                      child: Stack(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/notification.svg",
                            color: Colors.black,
                          ),
                          Positioned(
                            right: 3,
                            top: 2,
                            child: Visibility(
                              visible: true,
                              child: Container(
                                height: 8,
                                width: 8,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(50)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
            body: _pages[homeCubit.state.selectedIndex],
            drawer: AppDrawer(selectedMenu: homeCubit.state.selectedMenu),
            endDrawer: FilterDrawer(),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: homeCubit.state.selectedIndex,
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.grey.shade400,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              backgroundColor: Colors.white,
              elevation: 12,
              items: [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/icons/home_home.svg",
                    color: homeCubit.state.selectedIndex == 0
                        ? Colors.black
                        : null,
                  ),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/icons/home_search.svg",
                    color: homeCubit.state.selectedIndex == 1
                        ? Colors.black
                        : null,
                  ),
                  label: "Search",
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/icons/home_cart.svg",
                    color: homeCubit.state.selectedIndex == 2
                        ? Colors.black
                        : null,
                  ),
                  label: "Cart",
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "assets/icons/home_profile.svg",
                    color: homeCubit.state.selectedIndex == 3
                        ? Colors.black
                        : null,
                  ),
                  label: "Profile",
                ),
              ],
            ),
          );
        }));
  }
}
